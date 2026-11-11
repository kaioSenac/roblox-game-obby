# Framework API Documentation

Documentação das abstrações-base do template Roblox.

## Conteúdo

-   [IService](IService.md) --- classe-base para serviços.
-   [IComponent](IComponent.md) --- classe-base para componentes
    associados a tags do `CollectionService`.
-   [ICommand](ICommand.md) --- classe-base para comandos executáveis a
    partir de um contexto de chat.

## Convenções

-   Os exemplos e descrições refletem o código-fonte fornecido.
-   Métodos marcados como *override* devem ser implementados pelas
    classes derivadas quando necessário.
-   Esta documentação não presume comportamentos internos de `Pool`,
    `ServiceManager` ou de outros módulos que não foram fornecidos.
-   Os métodos-base `Start` de `IService` e `IComponent`, assim como
    `Runnable` de `ICommand`, são implementações padrão que emitem
    avisos; eles não executam a lógica específica da classe derivada.

## Estado da API

Esta documentação descreve a implementação atual. Consulte também a
seção **Pontos de atenção** de cada página para detalhes que merecem
revisão antes de considerar a API estável.
