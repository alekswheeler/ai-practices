@echo off
setlocal EnableDelayedExpansion

:: Arquivo de log
set LOG_FILE=auto-commit-log.txt

:: Limpa log antigo
if exist "%LOG_FILE%" del "%LOG_FILE%"

:: Timestamp para commit
for /f %%i in ('wmic os get localdatetime ^| find "."') do set datetime=%%i
set commitMsg=Commit automático - %datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2% %datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%

:: Mensagem de início
echo Iniciando commit automático...
echo.

:: Executa os comandos Git e redireciona saída de erro para log
(
    git add .
    git commit -m "%commitMsg%"
    git push
) 1>>"%LOG_FILE%" 2>&1

:: Verifica erro (código de saída do último comando)
if errorlevel 1 (
    echo.
    echo Algo de errado ocorreu, favor contactar a NEO. >> "%LOG_FILE%"
    echo Detalhes técnicos foram salvos em auto-commit-log.txt
    echo.
    echo =====================================
    echo Algo de errado ocorreu, favor contactar a NEO.
    echo Envie o arquivo auto-commit-log.txt gerado.
    echo =====================================
    pause
    exit /b 1
)

echo.
echo Commit e push realizados com sucesso!
pause
exit /b 0
