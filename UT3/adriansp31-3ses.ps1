param(
    [datetime]$FechaInicio,   # Fecha inicial para filtrar los eventos
    [datetime]$FechaFin       # Fecha final para filtrar los eventos
)

Write-Host
Write-Host "Inicios de sesión entre $FechaInicio y $FechaFin"
Write-Host

# Obtiene los eventos del registro Security con el ID 4624 (inicios de sesión exitosos)
Get-EventLog Security -InstanceId 4624 |

# Filtra solo los eventos que están dentro del rango de fechas indicado
Where-Object { $_.TimeGenerated -ge $FechaInicio -and $_.TimeGenerated -le $FechaFin } |

# Recorre cada evento encontrado
ForEach-Object {
    
    # El nombre del usuario está en el índice 5 de ReplacementStrings
    $usuario = $_.ReplacementStrings[5]

    # Excluye al usuario SYSTEM (inicios de sesión del propio sistema)
    if ($usuario -ne "SYSTEM") {
        
        # Muestra la fecha del evento y el usuario que inició sesión
        Write-Host "Fecha:" $_.TimeGenerated " - Usuario:" $usuario
    }
}
