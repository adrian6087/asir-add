# Guarda todos los nombres de los registros (Log) en una variable.
$tiporegistros = (Get-EventLog -List).Log

# Inicia el menú. Esto se repetirá hasta que elijan "0".
do {
    # Limpia la pantalla.
    Clear-Host
    
    # Muestra el título del menú.
    Write-Host "================================================"
    Write-Host "    MENÚ DE REGISTROS DE EVENTOS DEL SISTEMA    "
    Write-Host "================================================"
    Write-Host
    
    # Recorre la lista de nombres de registros uno por uno.
    for ($i = 0; $i -lt $tiporegistros.Count; $i++) {
        # Muestra la opción (Ej: "1. Application", "2. System", etc.)
        Write-Host "$($i + 1). $($tiporegistros[$i])"
    }

    # Muestra la opción para salir.
    Write-Host
    Write-Host "0. Salir del script"
    Write-Host
    Write-Host "================================================"
    Write-Host

    # Pregunta al usuario qué opción quiere.
    $opcion = Read-Host "Selecciona una opción"
    
    # Intenta convertir la respuesta a un número.
    $opcionNum = $opcion -as [int]
    
    
    # Si el usuario escribió "0"...
    if ($opcionNum -eq 0) {
        # ...le decimos adiós.
        Write-Host "Saliendo del script..."

    # Si el número es válido y está en la lista...
    } elseif (($opcionNum -ne $null) -and ($opcionNum -in (1..$tiporegistros.Count))) {
        
        # ...guardamos el nombre del registro que eligió (Ej: "System").
        $logSeleccionado = $tiporegistros[$opcionNum - 1]
        
        # Muestra un título con lo que va a hacer.
        Write-Host ""
        Write-Host "--- Mostrando los 12 eventos más recientes de '$logSeleccionado' ---"

        # Busca los 12 eventos más nuevos de ese registro y los muestra como tabla.
        Get-WinEvent -LogName $logSeleccionado -MaxEvents 12 | Format-Table TimeCreated, ProviderName, Message -AutoSize -Wrap

    # Si el usuario escribió cualquier otra cosa (un número malo o letras)...
    } else {
        # ...le decimos que se equivocó.
        Write-Host ""
        Write-Host "Opción no válida. Por favor, introduce un número del 0 al $($tiporegistros.Count)."
    }
    
    # Si el usuario NO eligió "0" (Salir)...
    if ($opcionNum -ne 0) {
        Write-Host
        # ...hacemos una pausa para que pueda leer los resultados.
        Read-Host "Presione Enter para volver al menú..."
    }

} while ($opcionNum -ne 0) # Vuelve al principio del menú (mientras no haya elegido "0").

# Mensaje final (solo se ve después de salir).
Write-Host "Script finalizado."
