# Como rodar o Fluig Monitor (desenvolvimento)

## Requisitos

| Item | Versão | Observação |
|---|---|---|
| Node.js | **18.x** (testado com 18.20.8) | O Node 24 instalado na máquina **não** serve para esta stack |
| Yarn | 1.22.x | O projeto foi feito com Yarn; o `yarn.lock` garante versões que funcionam |
| `.env` | já existe no repositório | SQLite em `prisma/fluig-monitor.db` |

> Por que Node 18? O projeto usa Electron 22, Prisma 4, TypeScript 4 e webpack 5 antigo.
> Com Node 20+ o `npm install` quebra por conflito de peer dependencies e algumas
> ferramentas de build deixam de funcionar.

## Rodar

A forma mais simples é dar **duplo clique em `run-dev.cmd`**. Ele:

1. coloca o Node 18 no `PATH`;
2. limpa a variável `ELECTRON_RUN_AS_NODE` (se ela existir, o Electron roda como
   Node puro e o app fecha sozinho);
3. instala as dependências se `node_modules` não existir;
4. executa `npm start`.

Alternativa manual (em um terminal com Node 18 ativo):

```bat
yarn start
```

Na primeira execução demora um pouco: o webpack compila o renderer e o DLL.
Quando aparecer `Compiled successfully` e a janela do **Fluig Monitor** abrir, está rodando.
O modo dev abre na porta **1212**.

### Variável NODE_HOME

O `run-dev.cmd` procura o Node 18 em `C:\Projetos_Rafael_Reis\.tools\node18`.
Se você instalar o Node 18 em outro lugar, defina antes:

```bat
set NODE_HOME=C:\caminho\do\node18
run-dev.cmd
```

## Instalar dependências do zero

```bat
yarn install
```

Se o Yarn não estiver disponível:

```bat
npm install --legacy-peer-deps
```

> `npm install` sem `--legacy-peer-deps` falha com `ERESOLVE` por causa do
> `react-test-renderer@17` convivendo com `react@18` (dependência só de teste).

O `postinstall` também precisa de um repositório Git (script `husky install`),
por isso a pasta foi inicializada com `git init`.

## Build de produção (opcional)

```bat
yarn package
```

Gera o instalador em `release/build`.

## Problemas comuns

| Sintoma | Causa / solução |
|---|---|
| `npm error code ERESOLVE` | Use Yarn ou `npm install --legacy-peer-deps` |
| App abre e fecha na hora, log com `Cannot use 'in' operator ... electron.app` | `ELECTRON_RUN_AS_NODE=1` no ambiente — remova a variável |
| `Port "1212" on "localhost" is already in use` | Feche outra instância ou use `set PORT=4343` antes de `yarn start` |
| Tela em branco / "Unable to load preload script" | Rode com Node 18 e garanta que `yarn start:renderer` compilou sem erros |
| Erro de Prisma nas migrações | Apague `prisma/fluig-monitor.db` e rode de novo: o app recria e migra |
| `husky - .git can't be found` | Rode `git init` antes de `yarn install` |

## O que foi ajustado neste ambiente

- `node_modules` instalado com Node 18.20.8 + Yarn 1.22.22 (respeitando `yarn.lock`);
- `electron` atualizado de `^22.0.2` para `^22.3.27` (mesma série 22, apenas correções);
- banco `prisma/fluig-monitor.db` criado e migrado;
- `git init` + commit inicial para o `husky install` funcionar;
- `run-dev.cmd` e `.nvmrc` adicionados.
