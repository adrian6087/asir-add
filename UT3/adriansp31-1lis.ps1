# Inicia el bucle del menú. Se repetirá hasta que se elija '0'.
do {
    # Limpia la pantalla.
    Clear-Host
    
    # Muestra las opciones del menú.
    Write-Host "=========================================="
    Write-Host "          MENÚ DE REGISTROS          "
    Write-Host "=========================================="
    Write-Host
    Write-Host "1. Mostrar eventos del Sistema (últimos 20)"
    Write-Host "2. Mostrar ERRORES del Sistema (último mes)"
    Write-Host "3. Mostrar ADVERTENCIAS de Aplicaciones (última semana)"
    Write-Host
    Write-Host "0. Salir del script"
    Write-Host

    # Lee la opción del usuario.
    $opcion = Read-Host "Selecciona una opción"

    # Ejecuta una acción según la opción elegida.
    switch ($opcion) {

        # Opción 1: Últimos 20 eventos del Sistema.
        '1' {
            Write-Host ""
            Write-Host "--- Mostrando los 20 eventos más recientes del 'Sistema' ---"
            
            # Obtiene los 20 eventos más nuevos del log 'System' y los formatea.
            Get-WinEvent -LogName 'System' -MaxEvents 20 | Format-Table TimeCreated, ProviderName, Message -AutoSize -Wrap
        }

        # Opción 2: Errores del Sistema del último mes.
        '2' {
            Write-Host ""
            Write-Host "--- Mostrando ERRORES del 'Sistema' del último mes ---"
            
            # Define la fecha de inicio (hace 1 mes).
            $fechaInicio = (Get-Date).AddMonths(-1)
            
            # Obtiene los eventos del 'System' que son Nivel 2 (Error)
            # y ocurrieron después de la fecha de inicio.
            Get-WinEvent -LogName 'System' | Where-Object { ($_.Level -eq 2) -and ($_.TimeCreated -ge $fechaInicio) } | Format-Table TimeCreated, Message -AutoSize -Wrap
        }

        # Opción 3: Advertencias de Aplicaciones de la última semana.
        '3' {
            Write-Host ""
            Write-Host "--- Mostrando ADVERTENCIAS de 'Aplicaciones' de la última semana ---"
            
            # Define la fecha de inicio (hace 7 días).
            $fechaInicio = (Get-Date).AddDays(-7)

            # Obtiene los eventos de 'Application' que son Nivel 3 (Advertencia)
            # y ocurrieron después de la fecha de inicio.
            Get-WinEvent -LogName 'Application' | Where-Object { ($_.Level -eq 3) -and ($_.TimeCreated -ge $fechaInicio) } | Format-Table TimeCreated, ProviderName, Message -AutoSize -Wrap
        }

        # Opción 0: Salir.
        '0' {
            Write-Host "Saliendo del script..."
        }

        # Opción no válida.
        default {
            Write-Host "Opción no válida. Por favor, intente de nuevo."
        }
    }

    # Si la opción no es '0' (Salir), pausa para ver el resultado.
    if ($opcion -ne '0') {
        Write-Host
        # Pausa hasta que el usuario presione Enter.
        Read-Host "Presione Enter para volver al menú..."
    }

} while ($opcion -ne '0') # Condición de salida del bucle.

# Mensaje final.
Write-Host "Script finalizado."
