function Pedir-Pizza {
    # Ingredientes base
    $ingbase = "mozzarella y tomate"

    # Preguntar si quiere pizza vegetariana
    $tipopizza = Read-Host "¿Deseas una pizza vegetariana? (S/N)"

    if ($tipopizza -eq "S") {
        $vegetariana = $true
        Write-Host "Ingredientes disponibles para pizza vegetariana:"
        Write-Host "1. Pimiento"
        Write-Host "2. Tofu"
        $opcion = Read-Host "Elige un ingrediente (1 o 2)"
        
        switch ($opcion) {
            "1" { $ingrediente = "Pimiento" }
            "2" { $ingrediente = "Tofu" }
        }

    } else {
        $vegetariana = $false
        Write-Host "Ingredientes disponibles para pizza no vegetariana:"
        Write-Host "1. Peperoni"
        Write-Host "2. Jamón"
        Write-Host "3. Salmón"
        $opcion = Read-Host "Elige un ingrediente (1, 2 o 3)"
        
        switch ($opcion) {
            "1" { $ingrediente = "Peperoni" }
            "2" { $ingrediente = "Jamón" }
            "3" { $ingrediente = "Salmón" }
        }
    }

    # Mostrar resumen del pedido
    Write-Host "`nTu pizza es:" -ForegroundColor Green
    if ($vegetariana) {
        Write-Host "Pizza vegetariana con $ingrediente, $base."
    } else {
        Write-Host "Pizza no vegetariana con $ingrediente, $base."
    }
}


# MENU
$opcion = 1
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
        '1'  Pedir-Pizza
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
