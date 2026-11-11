# IService

`IService` é a classe-base utilizada para criar serviços do lado do
servidor ou outras unidades de lógica que precisem compartilhar um ciclo
de vida e uma interface de comunicação.

A classe fornece estado de inicialização, identificação do serviço,
comunicação interna por `BindableEvent` e configuração de acesso externo
por meio de uma instância de `Pool`.

> **Importante:** o código apresentado não inclui a implementação de
> `Pool`. Portanto, esta página descreve como `IService` utiliza seus
> métodos, sem presumir detalhes adicionais sobre criação de instâncias,
> nomes de eventos ou tratamento de conexões.

## Responsabilidades

-   Criar uma instância identificada por nome.
-   Controlar se o serviço foi inicializado.
-   Fornecer métodos comuns que podem ser herdados por serviços
    derivados.
-   Permitir comunicação interna por `Bind` e `internalFire`.
-   Configurar handlers de Bindables e Remotes por meio de `Pool`.

## Criação

``` lua
local IService = require(path.to.IService)

local CheckpointService = {}
CheckpointService.__index = CheckpointService
setmetatable(CheckpointService, IService)

local Service = IService.new("CheckpointService")
setmetatable(Service, CheckpointService)

return Service
```

`IService.new(name)` cria uma tabela com os seguintes campos:

  ----------------------------------------------------------------------------
  Campo                   Valor inicial           Descrição
  ----------------------- ----------------------- ----------------------------
  `initialized`           `false`                 Indica se
                                                  `InitializeService` já foi
                                                  chamado.

  `name`                  argumento `name`        Nome usado para identificar
                                                  o serviço.

  `pool`                  `nil`                   Recebe a instância de `Pool`
                                                  criada por
                                                  `ConfigureExternalAccess`.

  `internalSignal`        novo `BindableEvent`    Canal de comunicação interna
                                                  do serviço.
  ----------------------------------------------------------------------------

O construtor valida que `name` seja uma string.

## API

### `IService.new(name)`

Cria uma nova instância da classe-base.

  Parâmetro   Tipo       Descrição
  ----------- ---------- ------------------
  `name`      `string`   Nome do serviço.

**Retorno:** uma instância de `IService`.

**Validação:** gera erro se `name` não for uma string.

### `:ConfigureExternalAccess(modules, restrictAccess)`

Configura os handlers de comunicação do serviço.

  -----------------------------------------------------------------------
  Parâmetro               Tipo                    Descrição
  ----------------------- ----------------------- -----------------------
  `modules`               `table`                 Tabela consultada para
                                                  localizar a função
                                                  associada ao
                                                  identificador recebido.
                                                  Normalmente, a própria
                                                  instância do serviço.

  `restrictAccess`        `table`                 Lista adicional de
                                                  métodos que o código
                                                  pretende bloquear no
                                                  caminho de Remote.
  -----------------------------------------------------------------------

O método:

1.  Retorna imediatamente se `modules` for `nil`.
2.  Cria uma `Pool` usando `self:GetServiceNamespace()` como namespace.
3.  Define uma lista de métodos-base que não devem ser expostos pelo
    controlador de Remote.
4.  Adiciona os métodos recebidos em `restrictAccess` à lista.
5.  Registra `bindableAccess` para BindableEvent e BindableFunction.
6.  Registra `remoteAccesController` para RemoteEvent e RemoteFunction.
7.  Armazena a instância criada em `self.pool`.

**Handler de Bindable:** procura `modules[event]` e, se encontrar uma
função, chama `fn(modules, ...)`.

**Handler de Remote:** recebe `player`, procura `modules[event]` e, se
encontrar uma função não bloqueada, chama `fn(modules, player, ...)`.

A implementação atual não aplica a lista `defaultMethodsBlocked` ao
handler de Bindable. Isso é compatível com uma separação em que
Bindables são usados para comunicação dentro do mesmo contexto de
execução, enquanto Remotes atravessam a fronteira cliente-servidor. A
validação de dados e permissões recebidos por Remote continua sendo
responsabilidade do código do servidor.

### `:Start()`

Método de ciclo de vida destinado a ser sobrescrito pela classe
derivada.

A implementação-base emite um `warn` informando que `Start()` não foi
implementado para aquele serviço.

Exemplo:

``` lua
function CheckpointService.Start(self)
    self.checkpointPositionsPool = {}
end
```

### `:Bind(callback)`

Conecta `callback` ao evento interno `internalSignal.Event`.

  -----------------------------------------------------------------------
  Parâmetro               Tipo                    Descrição
  ----------------------- ----------------------- -----------------------
  `callback`              `function`              Função chamada quando o
                                                  sinal interno é
                                                  disparado.

  -----------------------------------------------------------------------

A conexão é criada com `BindableEvent.Event:Connect`.

### `:internalFire(...)`

Dispara o `BindableEvent` interno, encaminhando os argumentos recebidos
para os callbacks conectados por `Bind`.

### `:InitializeService()`

Marca o serviço como inicializado.

**Comportamento:** exige que `initialized` ainda seja `false`; caso
contrário, gera erro. Em seguida, define `initialized = true`.

Este método apenas atualiza o estado. A implementação apresentada não
chama automaticamente um método `Initialize` da classe derivada.

### `:IsInitialized()`

Retorna um booleano indicando se o serviço foi inicializado.

### `:GetServiceState()`

Retorna uma das strings:

-   `"INITIALIZED"` --- quando `IsInitialized()` retorna `true`.
-   `"NON_INITIALIZED"` --- caso contrário.

### `:GetServiceNamespace()`

Retorna o nome do serviço (`self.name`). Esse valor é utilizado como
namespace ao criar a `Pool`.

### `:AssertInitialized()`

Gera erro se o serviço ainda não tiver sido inicializado. Não retorna um
valor quando a validação passa.

## Exemplo de uso

``` lua
local IService = require(path.to.IService)

local ExampleService = {}
ExampleService.__index = ExampleService
setmetatable(ExampleService, IService)

local Service = IService.new("ExampleService")
setmetatable(Service, ExampleService)

function ExampleService.Start(self)
    self:AssertInitialized()
    print(self:GetServiceNamespace(), "started")
end

function ExampleService.Register(self, value)
    print("Received:", value)
end

function ExampleService.Initialize(self)
    self:InitializeService()
    self:ConfigureExternalAccess(self, {})
end

return Service
```

O exemplo ilustra a herança por metatables e a configuração da
instância. A ordem real de inicialização depende do gerenciador de
serviços utilizado pelo projeto.

## Pontos de atenção na implementação atual

1.  **Representação de `defaultMethodsBlocked`:** a tabela é preenchida
    como uma lista sequencial com `table.insert`, mas consultada com
    `defaultMethodsBlocked[event]`. Se `event` for o identificador/nome
    do método, essa consulta não verifica os valores da lista. Para uma
    consulta por chave, use um conjunto, por exemplo
    `blocked[method] = true`, e confirme que o identificador recebido
    corresponde ao mesmo tipo de chave.
2.  **`restrictAccess` opcional:** o método percorre `restrictAccess`
    sem valor padrão. Se o argumento puder ser omitido, inicialize-o
    como `{}` antes do loop.
3.  **`modules` e identificadores:** confirme no contrato de `Pool` qual
    tipo chega em `event` e como ele corresponde às chaves de `modules`.
4.  **Ciclo de vida:** `InitializeService` apenas altera uma flag. Se
    existir uma etapa de inicialização específica, ela precisa ser
    chamada pelo gerenciador ou implementada explicitamente.
5.  **Limpeza:** `internalSignal` é criado no construtor, mas o código
    fornecido não apresenta um método para desconectá-lo ou destruí-lo.
    Considere adicionar uma rotina de encerramento se as instâncias
    puderem ser descartadas.
6.  **Acesso por Remote:** bloquear nomes de métodos não substitui
    validação de argumentos, autorização por jogador e verificações de
    estado dentro de cada operação exposta.

## Resumo

`IService` padroniza a estrutura básica dos serviços, oferece um estado
simples de inicialização e centraliza a configuração de comunicação
interna e cliente-servidor. As classes derivadas implementam a lógica
específica do domínio e podem sobrescrever `Start`.
