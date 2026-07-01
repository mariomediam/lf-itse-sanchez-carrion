@echo off

title Backend Django - Waitress LF ITSE - NO CERRAR

color 0A

echo ============================================================
echo   BACKEND DJANGO - SISTEMA LF ITSE
echo ============================================================
echo.
echo   El servidor backend se esta ejecutando con Waitress.
echo.
echo   NO CIERRE ESTA VENTANA.
echo   Si cierra esta ventana, el backend dejara de funcionar.
echo.
echo   URL local:
echo   http://127.0.0.1:8003
echo.
echo   Para detener el backend correctamente, presione CTRL + C.
echo ============================================================
echo.

set PYTHONHOME=
set PYTHONPATH=

if not exist E:\sistema_lf_itse\logs mkdir E:\sistema_lf_itse\logs

cd /d E:\sistema_lf_itse\backend

call E:\sistema_lf_itse\venv\Scripts\activate.bat

python -m waitress ^
  --listen=0.0.0.0:8003 ^
  backend_api.wsgi:application ^
  >> E:\sistema_lf_itse\logs\backend_waitress.log 2>&1

echo.
echo ============================================================
echo   El backend se ha detenido.
echo   Revise el log:
echo   E:\sistema_lf_itse\logs\backend_waitress.log
echo ============================================================
pause