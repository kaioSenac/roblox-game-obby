# IComponent

`IComponent` é uma classe-base para componentes associados a uma tag do
`CollectionService`.

Ela observa quando instâncias com determinada tag são adicionadas ou
removidas e retransmite essas notificações por meio de um
`BindableEvent` próprio.

## Responsabilidades

-   Armazenar o nome e a tag do componente.
-   Conectar-se aos sinais de adição e remoção do `CollectionService`.
-   Notificar consumidores quando uma instância marcada é encontrada ou
    removida.
-   Oferecer métodos básicos de consulta e estado de inicialização.
-   Disponibilizar `Start` como método destinado a ser sobrescrito.

## Criação

``` lua
local IComponent = require(path.to.IComponent)

local DamageComponent = {}
DamageComponent.__index = DamageComponent
setmetatable(DamageComponent, IComponent)

local Component = IComponent.new({
    name = "DamageComponent",
    tag = "DamageBlock"
})

setmetatable(Component, DamageComponent)

return Component
```

`IComponent.new(opts)` espera uma tabela com:

  Campo         Tipo       Descrição
  ------------- ---------- -----------------------------------------
  `opts.name`   `string`   Nome identificador do componente.
  `opts.tag`    `string`   Tag observada pelo `CollectionService`.

A instância recebe os campos `tag`, `name`, `initialized` (inicialmente
`false`) e `instanceAdded` (um novo `BindableEvent`).

## API

### `IComponent.new(opts)`

Cria uma instância de componente.

**Parâmetro:** tabela `opts` com `name` e `tag`.

**Retorno:** uma instância de `IComponent`.

### `:FireInitialize()`

Ativa a observação da tag configurada.

O método:

1.  Verifica se `_fired` já está definido como verdadeiro.
2.  Conecta `CollectionService:GetInstanceAddedSignal(self.tag)`.
3.  Conecta `CollectionService:GetInstanceRemovedSignal(self.tag)`.
4.  Percorre as instâncias que já possuem a tag com
    `CollectionService:GetTagged(self.tag)`.
5.  Emite `"ADDED"` para cada instância encontrada.
6.  Define `_fired = true`.

O evento interno `instanceAdded` é utilizado tanto para adições quanto
para remoções:

-   `"ADDED", instance`
-   `"REMOVED", instance`

**Observação:** apesar do nome `instanceAdded`, o evento também
transmite notificações de remoção.

### `:Start()`

Método destinado a ser sobrescrito pela classe derivada.

A implementação-base emite um aviso informando que o componente não
possui uma implementação de `Start`.

### `:JoinIntoInstaceAddedEvent(callback)`

Conecta um callback ao evento interno, mas executa esse callback somente
quando o tipo de notificação é `"ADDED"`.

  -----------------------------------------------------------------------
  Parâmetro               Tipo                    Descrição
  ----------------------- ----------------------- -----------------------
  `callback`              `(...any) -> ()`        Função chamada com a
                                                  instância adicionada.

  -----------------------------------------------------------------------

Exemplo:

``` lua
Component:JoinIntoInstaceAddedEvent(function(instance)
    print("Tagged instance added:", instance:GetFullName())
end)
```

O nome do método está escrito exatamente como aparece no código atual
(`Instace`). Considere corrigir para `JoinIntoInstanceAddedEvent` antes
de estabilizar a API, ou manter um alias de compatibilidade caso já
existam chamadas usando o nome atual.

### `:GetName()`

Retorna o nome do componente.

### `:GetTag()`

Retorna a tag observada pelo componente.

### `:Initialize()`

Define `initialized = true`.

Este método não chama `FireInitialize` nem executa automaticamente
`Start`.

### `:HasInitialized()`

Retorna o valor booleano de `initialized`.

## Exemplo de componente derivado

``` lua
local IComponent = require(path.to.IComponent)

local DamageComponent = {}
DamageComponent.__index = DamageComponent
setmetatable(DamageComponent, IComponent)

local Component = IComponent.new({
    name = "DamageComponent",
    tag = "DamageBlock"
})

setmetatable(Component, DamageComponent)

function DamageComponent.Start(self)
    self:JoinIntoInstaceAddedEvent(function(instance)
        print("Configuring damage block:", instance.Name)
    end)

    self:FireInitialize()
    self:Initialize()
end

return Component
```

Este exemplo demonstra a intenção de uso: a classe derivada reage às
instâncias que possuem a tag configurada. A ordem de chamadas deve ser
adaptada ao ciclo de vida adotado pelo projeto.

## Pontos de atenção na implementação atual

1.  **`_fired` não é inicializado explicitamente:** atualmente começa
    como `nil`, e a validação `assert(not self._fired, ...)` permite a
    primeira chamada. É mais claro inicializá-lo como `false` no
    construtor.
2.  **`instanceAdded` também transmite remoções:** considere renomeá-lo
    para algo como `instanceChanged` ou documentar explicitamente os
    dois tipos de mensagem.
3.  **Não há conexão para receber `"REMOVED"` pela API pública
    apresentada:** `JoinIntoInstaceAddedEvent` filtra apenas `"ADDED"`.
    Se consumidores precisarem reagir à remoção, adicione um método
    próprio ou um método genérico para os dois eventos.
4.  **Conexões não são armazenadas:** `FireInitialize` conecta aos
    sinais do `CollectionService`, mas não guarda os objetos
    `RBXScriptConnection`. Considere armazená-los para permitir
    desconexão e limpeza.
5.  **Inicialização possui duas flags distintas:** `_fired` indica que
    os sinais foram conectados; `initialized` é alterado por
    `Initialize`. Elas representam estados diferentes e devem permanecer
    documentadas separadamente.
6.  **Validação de opções:** o construtor não valida se `opts`,
    `opts.name` e `opts.tag` existem ou têm os tipos esperados.

## Resumo

`IComponent` observa instâncias identificadas por uma tag do
`CollectionService` e oferece uma forma de reagir à entrada dessas
instâncias no conjunto observado. As classes derivadas podem adicionar o
comportamento específico de cada tipo de componente.
