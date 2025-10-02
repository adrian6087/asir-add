# MENU
while ($opcion -ne '0') do {
    Clear-Host
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "     MENÚ DE EJERCICIOS" -ForegroundColor Cyan
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "1) Pizza"
    Write-Host "0) Salir"
    Write-Host "==============================" -ForegroundColor Cyan

    $opcion = Read-Host "Elige una opción (0-15)"

    switch ($opcion) {
        '1'  {  }
        '0'  {
            Write-Host "Saliendo..." -ForegroundColor Yellow
            break
        }
        default {
            Write-Host "Opción no válida" -ForegroundColor Red
        }
    }

    if ($opcion -ne '0') {
        Write-Host ""
        Read-Host "Presiona Enter para continuar..."
    }
} 
