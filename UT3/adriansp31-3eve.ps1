# Guarda todos los nombres de los registros en una variable.
$tiporegistros = (Get-EventLog -List).Log

# Inicia el menú. Esto se repetirá hasta que elijan "0".
do {
    Clear-Host
    Write-Host "================================================"
    Write-Host "    MENÚ DE REGISTROS DE EVENTOS DEL SISTEMA    "
    Write-Host "================================================"
    Write-Host
    
    # Recorre la lista de nombres de registros uno por uno.
    for ($i = 0; $i -lt $tiporegistros.Count; $i++) {
        # Muestra la opción
        Write-Host "$($i + 1). $($tiporegistros[$i])"
    }

    Write-Host
    Write-Host "0. Salir del script"
    Write-Host
    Write-Host "================================================"
    Write-Host

    $opcion = Read-Host "Selecciona una opción"
    
    # Convierte la respuesta a un número.
    $opcionNum = $opcion -as [int]
    
    
    # Si el usuario escribió 0 salimos.
    if ($opcionNum -eq 0) {
        Write-Host "Saliendo del script..."

    # Verificamos si el número es válido y está en la lista.
    } elseif (($opcionNum -ne $null) -and ($opcionNum -in (1..$tiporegistros.Count))) {
        
        # Guardamos el nombre del registro que eligió.
        $logSeleccionado = $tiporegistros[$opcionNum - 1]
        
        # Muestra un título con lo que va a hacer.
        Write-Host ""
        Write-Host "--- Mostrando los 12 eventos más recientes de '$logSeleccionado' ---"

        # Busca los 12 eventos más nuevos de ese registro y los muestra como tabla.
        Get-WinEvent -LogName $logSeleccionado -MaxEvents 12 | Format-Table TimeCreated, ProviderName, Message -AutoSize -Wrap

    } else {
        # Si el usuario escribió cualquier otra cosa mostramos entre que rango tiene que elegir.
        Write-Host ""
        Write-Host "Opción no válida. Por favor, introduce un número del 0 al $($tiporegistros.Count)."
    }
    
    if ($opcionNum -ne 0) {
        Write-Host
        # Si no es 0 hacemos una pausa para que pueda leer los resultados.
        Read-Host "Presione Enter para volver al menú..."
    }

} while ($opcionNum -ne 0) # Vuelve al principio del menú (mientras no haya elegido "0").

# Mensaje final.
Write-Host "Script finalizado."

# Mensaje final (solo se ve después de salir).
Write-Host "Script finalizado."
