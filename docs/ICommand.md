# ICommand

`ICommand` é uma classe-base para representar comandos identificados por
nome, descrição e uma propriedade de restrição.

A implementação atual fornece os metadados do comando e define
`Runnable` como método destinado a ser sobrescrito pelas classes
derivadas.

## Responsabilidades

-   Armazenar o nome do comando.
-   Armazenar a descrição apresentada para o comando.
-   Armazenar se o comando é restrito.
-   Definir um ponto de extensão para a execução do comando.

## Tipos

A implementação declara dois tipos Luau:

``` lua
type ICommandOptions = {
    name: string,
    desc: string,
    restricted: boolean
}
```

`ICommandOptions` descreve as opções necessárias para construir um
comando.

`ICommandType` descreve a instância resultante, com os campos:

  -----------------------------------------------------------------------
  Campo                   Tipo                    Descrição
  ----------------------- ----------------------- -----------------------
  `commandName`           `string`                Nome do comando.

  `commandDesc`           `string`                Descrição do comando.

  `commandRestricted`     `boolean`               Indica se o comando é
                                                  marcado como restrito.
  -----------------------------------------------------------------------

## Criação

``` lua
local ICommand = require(path.to.ICommand)

local Command = ICommand.new({
    name = "announce",
    desc = "Sends an announcement",
    restricted = true
})
```

### `ICommand.new(options)`

Cria uma instância de comando.

  Campo de `options`   Tipo        Descrição
  -------------------- ----------- -------------------------
  `name`               `string`    Nome do comando.
  `desc`               `string`    Descrição do comando.
  `restricted`         `boolean`   Indicador de restrição.

**Retorno:** uma instância tipada como `ICommandType`.

O construtor armazena os valores nos campos `commandName`, `commandDesc`
e `commandRestricted`.

## API

### `:Runnable(context, message)`

Método destinado a ser sobrescrito pela implementação concreta do
comando.

  -----------------------------------------------------------------------
  Parâmetro               Tipo                    Descrição
  ----------------------- ----------------------- -----------------------
  `context`               `TextSource`            Origem/contexto de
                                                  texto associado à
                                                  solicitação.

  `message`               `string`                Mensagem recebida.
  -----------------------------------------------------------------------

A implementação-base emite um aviso informando que `Runnable()` não
existe para o comando atual.

A classe-base não executa parsing, autorização, validação ou
processamento da mensagem. Esses comportamentos não estão presentes no
código fornecido e devem ser definidos pelo sistema que gerencia os
comandos ou pelas classes derivadas.

## Exemplo de comando derivado

``` lua
local ICommand = require(path.to.ICommand)

local AnnounceCommand = {}
AnnounceCommand.__index = AnnounceCommand
setmetatable(AnnounceCommand, ICommand)

local Command = ICommand.new({
    name = "announce",
    desc = "Sends an announcement",
    restricted = true
})

setmetatable(Command, AnnounceCommand)

function AnnounceCommand.Runnable(self, context, message)
    print(context, message)
end

return Command
```

O exemplo ilustra a sobrescrita de `Runnable`. A interpretação de
`context` e o tratamento da mensagem dependem do sistema de comandos do
projeto.

## Pontos de atenção na implementação atual

1.  **`restricted` é apenas metadado:** o código armazena o booleano,
    mas não aplica nenhuma regra de autorização. O sistema executor
    precisa verificar essa propriedade antes de chamar `Runnable`.
2.  **Não há validação em tempo de execução:** o construtor não verifica
    se `options` ou seus campos estão presentes e possuem os tipos
    esperados. Os tipos Luau ajudam na análise estática, mas não
    substituem validação de dados externos.
3.  **`Runnable` é um ponto de extensão:** a implementação-base apenas
    emite um aviso. Cada comando concreto deve sobrescrevê-lo para
    executar uma ação.
4.  **Sem getters na API atual:** os metadados ficam disponíveis nos
    campos da instância. Se quiser encapsular o acesso, considere
    adicionar métodos como `GetName`, `GetDescription` e `IsRestricted`.

## Resumo

`ICommand` padroniza os metadados e o ponto de execução dos comandos. A
classe-base não implementa o sistema de despacho nem as regras de
permissão; ela fornece uma estrutura comum para comandos concretos.
