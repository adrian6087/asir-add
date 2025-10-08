# 1. Pedir una pizza

function pizza {
    # Variables de ingredientes
    $ingbase = "mozzarella y tomate"
    $vegeta = @("Pimiento", "Tofu")
    $carni = @("Peperoni", "Jamon", "Salmon")

    # Preguntar si quiere pizza vegetariana
    $tipopizza = Read-Host "¿Deseas una pizza vegetariana? (S/N)"

    if ($tipopizza -eq "S") {
        $opcion = Read-Host "Elige un ingrediente (Pimiento o Tofu)"

        if ($vegeta -contains $opcion) {
            Write-Host "Pizza vegetariana con $opcion, $ingbase."
        } else {
            Write-Host "Ingrediente no válido."
        }

    } elseif ($tipopizza -eq "N") {
        $opcion = Read-Host "Elige un ingrediente (Peperoni, Jamon o Salmon)"

        if ($carni -contains $opcion) {
            Write-Host "Pizza no vegetariana con $opcion, $ingbase."
        } else {
            Write-Host "Ingrediente no válido."
        }

    } else {
        Write-Host "Opción inválida. Por favor escribe S o N."
    }
}


# 2. Calcular el número de días pares e impares que hay en un año bisiesto

function dias {
    $diasPares = 0
    $diasImpares = 0

    # Array con la cantidad de días de cada mes en un año bisiesto
    $anobi = @(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

    # Sumar todos los días del año bisiesto
    $totalDias = 0
    foreach ($mes in $anobi) {
        $totalDias += $mes
    }

    # Contar días pares e impares
    for ($i = 1; $i -le $totalDias; $i++) {
        if ($i % 2 -eq 0) {
            $diasPares++
        } else {
            $diasImpares++
        }
    }

    Write-Host "En un año bisiesto hay:"
    Write-Host "$diasPares días pares"
    Write-Host "$diasImpares días impares"
}


# 3. Menu de usuarios

function menu_usuarios {
    $opcion = ""
    while ($opcion -ne "0") {
        Write-Host "`n=== MENÚ DE USUARIOS ==="
        Write-Host "1. Listar usuarios"
        Write-Host "2. Crear usuario"
        Write-Host "3. Eliminar usuario"
        Write-Host "4. Modificar nombre de usuario"
        Write-Host "0. Salir"
        $opcion = Read-Host "Elija una opción (1-4)"

        if ($opcion -eq "1") {
            Get-LocalUser | Select Name
        }
        elseif ($opcion -eq "2") {
            $usuario = Read-Host "Ingrese el nombre del nuevo usuario"
            $clave = Read-Host "Ingrese la contraseña" -AsSecureString
            New-LocalUser -Name $usuario -Password $clave
            Add-LocalGroupMember -Group "Users" -Member $usuario
            Write-Host "Usuario creado: $usuario"
        }
        elseif ($opcion -eq "3") {
            $usuario = Read-Host "Ingrese el nombre del usuario a eliminar"
            Remove-LocalUser -Name $usuario
            Write-Host "Usuario eliminado: $usuario"
        }
        elseif ($opcion -eq "4") {
            $usuario = Read-Host "Ingrese el nombre del usuario actual"
            $nuevo = Read-Host "Ingrese el nuevo nombre"
            Rename-LocalUser -Name $usuario -NewName $nuevo
            Write-Host "Usuario renombrado a: $nuevo"
        }
        elseif ($opcion -eq "0") {
            Write-Host "Saliendo..."
        }
        else {
            Write-Host "Opción no válida"
        }
    }
}


# 4. Menu grupos

function menu_grupos {
    $opcion = ""
    while ($opcion -ne "6") {
        Clear-Host
        Write-Host "1. Listar grupos y miembros"
        Write-Host "2. Crear grupo"
        Write-Host "3. Eliminar grupo"
        Write-Host "4. Agregar usuario a grupo"
        Write-Host "5. Eliminar usuario de grupo"
        Write-Host "6. Salir"
        $opcion = Read-Host "Seleccione una opción"

        if ($opcion -eq "1") {
            Get-LocalGroup | ForEach-Object {
                Write-Host "`nGrupo: $($_.Name)"
                Get-LocalGroupMember -Group $_.Name | ForEach-Object {
                    Write-Host " - $($_.Name)"
                }
            }
        }
        
        elseif ($opcion -eq "2") {
            $nombre = Read-Host "Nombre del nuevo grupo"
            New-LocalGroup -Name $nombre
        }
        
        elseif ($opcion -eq "3") {
            $nombre = Read-Host "Nombre del grupo a eliminar"
            Remove-LocalGroup -Name $nombre
        }
    
        elseif ($opcion -eq "4") {
            $grupo = Read-Host "Nombre del grupo"
            $usuario = Read-Host "Nombre del usuario"
            Add-LocalGroupMember -Group $grupo -Member $usuario
        }
        
        elseif ($opcion -eq "5") {
            $grupo = Read-Host "Nombre del grupo"
            $usuario = Read-Host "Nombre del usuario"
            Remove-LocalGroupMember -Group $grupo -Member $usuario
        }
}


# 5. DISCOS
function diskp {
    # Solicitar número de disco
    $diskNumber = Read-Host "Introduce el número del disco a utilizar"

    # Verificar que sea un número
    if (-not ($diskNumber -match '^\d+$')) {
        Write-Host "Error: Debes introducir un número válido." -ForegroundColor Red
        return
    }

    # Obtener información del disco
    $disk = Get-Disk -Number $diskNumber -ErrorAction SilentlyContinue
    if (-not $disk) {
        Write-Host "Error: No se encontró el disco número $diskNumber." -ForegroundColor Red
        return
    }

    # Mostrar tamaño en GB (redondeado)
    $sizeGB = [Math]::Round($disk.Size / 1GB, 2)
    Write-Host "Tamaño del disco $diskNumber: $sizeGB GB"

    # Confirmación de seguridad
    $confirm = Read-Host "¿Estás seguro de que quieres limpiar y particionar este disco? (escribe 'SI' para continuar)"
    if ($confirm -ne 'SI') {
        Write-Host "Operación cancelada." -ForegroundColor Yellow
        return
    }

    # Limpiar el disco con DiskPart
    $diskpartScript = @"
select disk $diskNumber
clean
"@
    $diskpartScript | diskpart

    # Crear particiones de 1 GB hasta que no quede espacio
    $remaining = $disk.Size
    $partitionSizeBytes = 1GB
    $i = 1

    while ($remaining -ge $partitionSizeBytes) {
        $diskpartScript = @"
select disk $diskNumber
create partition primary size=1024
"@
        $diskpartScript | diskpart
        Write-Host "Creada partición $i de 1 GB"
        $remaining -= $partitionSizeBytes
        $i++
    }

    Write-Host "Proceso completado. Se crearon $($i - 1) particiones de 1 GB."
}


# 6. Contraseña valida

function contraseña {
    
    [string]$contra = (Read-Host "Introduce una contraseña")

    if ($contra.Length -ge 8 -and $contra -match '[a-z]' -and $contra -match '[A-Z]' -and $contra -match '\d' -and $contra -match '[^\w\s]') {
        Write-Host "Contraseña válida." -ForegroundColor Green
    } else {
        Write-Host "Contraseña no válida." -ForegroundColor Red
    }
}


# 7. Fibonnaci simple

$n = [int](Read-Host "¿Cuántos números de Fibonacci quieres? ")

$a = 0
$b = 1

Write-Host "Los primeros $n números de Fibonacci son:"

for ($i = 0; $i -lt $n; $i++) {
    Write-Host $a
    $temp = $a + $b
    $a = $b
    $b = $temp
}


# 8. Fibonacci recursivo

function FibonacciRecu($n) {
    if ($n -le 1) {
        return $n
    } else {
        return (Fibonacci($n - 1) + Fibonacci($n - 2))
    }
}

$n = [int](Read-Host "¿Cuántos números de Fibonacci quieres? ")

for ($i = 0; $i -lt $n; $i++) {
    Write-Output (Fibonacci $i)
}


# 9. Monitorear el uso de la CPU

function MonitorearCPU {
    param (
        [int]$duracionSegundos = 30,
        [int]$intervaloSegundos = 5
    )

    $usos = @()
    $cantidadMediciones = [math]::Floor($duracionSegundos / $intervaloSegundos)

    for ($i = 0; $i -lt $cantidadMediciones; $i++) {
        $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
        $usos += $cpu
        Start-Sleep -Seconds $intervaloSegundos
    }

    $promedio = ($usos | Measure-Object -Average).Average
    Write-Host "Promedio de uso de CPU durante $duracionSegundos segundos: {0:N2}%" -f $promedio
}


# 10. Espacio libre

function alertaEspacio {
    $logFile = "alerta_espacio_log.txt"
    $unidades = Get-PSDrive -PSProvider FileSystem

    foreach ($u in $unidades) {
        $porcentajeLibre = ($u.Free / $u.Used + $u.Free) * 100
        if ($porcentajeLibre -lt 10) {
            $mensaje = "ALERTA: Unidad $($u.Name) con sólo {0:N2}% de espacio libre." -f $porcentajeLibre
            Write-Host $mensaje -ForegroundColor Red
            Add-Content $logFile $mensaje
        }
    }
}


# 11. Copias comprimidas

function copiasMasivas {
    $origenBase = "C:\Users"
    $destinoBase = "C:\CopiasSeguridad"

    # Crear carpeta destino si no existe
    if (-not (Test-Path $destinoBase)) {
        New-Item -ItemType Directory -Path $destinoBase | Out-Null
    }

    # Obtener carpetas de usuarios (excluye carpetas especiales como Public, Default, etc. si quieres)
    $usuarios = Get-ChildItem -Path $origenBase -Directory

    foreach ($usuario in $usuarios) {
        $origen = $usuario.FullName
        $destinoZip = Join-Path $destinoBase ($usuario.Name + ".zip")

        # Crear copia comprimida del perfil
        Compress-Archive -Path $origen -DestinationPath $destinoZip -Force
        Write-Host "Copia creada para usuario $($usuario.Name) en $destinoZip"
    }
}


# 12. Crear usuarios con documentos

function automatizarps {
    $directorio = "C:\UsuariosDocs"
    $archivos = Get-ChildItem $directorio -File

    if ($archivos.Count -eq 0) {
        Write-Host "Listado vacío"
        return
    }

    foreach ($archivo in $archivos) {
        $usuario = $archivo.BaseName
        $ruta = "C:\Users\$usuario"

        New-LocalUser -Name $usuario -NoPassword -ErrorAction SilentlyContinue
        New-Item $ruta -ItemType Directory -Force | Out-Null

        Get-Content $archivo.FullName | ForEach-Object {
            New-Item "$ruta\$_" -ItemType Directory -Force | Out-Null
        }

        Remove-Item $archivo.FullName
    }
}


# 13. Ping masivo



# 14. Evento + agenda?



# 15. Limpieza



# === Menú principal ===
$opcion = 1
while ($opcion -ne '0') {
    Clear-Host
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "     MENÚ DE EJERCICIOS" -ForegroundColor Cyan
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "1) Pedir pizza"
    Write-Host "2) Contar dias par y impar (bisiesto)"
    Write-Host "3) Menu acciones con usuarios"
    Write-Host "4) Limpieza"
    Write-Host "5) Verificar espacio en disco"
    Write-Host "6) Generar contraseña"
    Write-Host "7) Fibonacci"
    Write-Host "8) Fibonacci Recursivo"
    Write-Host "9) Monitoreo"
    Write-Host "10) Alerta por espacio"
    Write-Host "11) Copias masivas"
    Write-Host "12) Automatizar PowerShell"
    Write-Host "13) Barrido de red"
    Write-Host "14) Crear evento"
    Write-Host "15) Limpieza (repetida)"
    Write-Host "0) Salir"
    Write-Host "==============================" -ForegroundColor Cyan

    $opcion = Read-Host "Elige una opción (0-15)"

    switch ($opcion) {
        '1'  { pizza }
        '2'  { dias }
        '3'  { menu_usuarios }
        '4'  { limpieza }
        '5'  { diskp }
        '6'  { contraseña }
        '7'  { Fibonacci }
        '8'  { FibonacciRecu }
        '9'  { monitoreo }
        '10' { alertaEspacio }
        '11' { copiasMasivas }
        '12' { automatizarps }
        '13' { barrido }
        '14' { evento }
        '15' { limpieza }
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
