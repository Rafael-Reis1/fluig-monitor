@echo off
setlocal
cd /d "%~dp0"

rem ---------------------------------------------------------------------------
rem Fluig Monitor - modo de desenvolvimento
rem Requer Node.js 18. O projeto usa Electron 22 + Prisma 4 + webpack 5 antigo,
rem que nao funcionam corretamente com Node 20+.
rem ---------------------------------------------------------------------------

if "%NODE_HOME%"=="" set "NODE_HOME=C:\Projetos_Rafael_Reis\.tools\node18"

if not exist "%NODE_HOME%\node.exe" (
  echo [ERRO] Node.js 18 nao encontrado em: %NODE_HOME%
  echo.
  echo Instale o Node 18 ou defina NODE_HOME apontando para a pasta dele:
  echo    set NODE_HOME=C:\caminho\para\node18
  echo.
  pause
  exit /b 1
)

set "PATH=%NODE_HOME%;%PATH%"

rem Se esta variavel estiver definida, o Electron roda como Node puro e o app
rem quebra com "Cannot use 'in' operator..." / tela nao abre.
set "ELECTRON_RUN_AS_NODE="
set "YARN_IGNORE_NODE=1"

if not exist "node_modules" (
  echo Dependencias ausentes. Instalando com npm...
  call npm install --legacy-peer-deps
  if errorlevel 1 goto :erro
)

echo.
echo Iniciando o Fluig Monitor (Node %NODE_HOME%)...
echo.
call npm start
if errorlevel 1 goto :erro
exit /b 0

:erro
echo.
echo A aplicacao terminou com erro. Veja as mensagens acima.
pause
exit /b 1
