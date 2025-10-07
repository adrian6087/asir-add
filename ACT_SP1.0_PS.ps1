# 1. Pedir una pizza

function pizza {
    # Variables de ingredientes
    $ingbase = "mozzarella y tomate"
    vegeta = ["Pimineto", "Tofu"]
    carni = ["Peperoni", "Jamon", "Salmon"]

    # Preguntar si quiere pizza vegetariana
    $tipopizza = Read-Host "¿Deseas una pizza vegetariana? (S/N)"

    if ($tipopizza -eq "S") {
        $opcion = Read-Host "Elige un ingrediente (Pimiento o Tofu)"

        if ($opcion in vegeta) {
        Write-Host "Pizza vegetariana con $opcion, $ingbase."
       
        } else {
        Write-Host "Ingrediente no valido."
    
    } else {
    
        $opcion = Read-Host "Elige un ingrediente (Peperoni, Jamon o Salmon)"
        if ($opcion in carni) {
            Write-Host "Pizza no vegetariana con $opcion, $ingbase."
    
        } else {
            Write-Host "Ingrediente no valido."}
        }
    }
}

# 2. Calcular el número de días pares e impares que hay en un año bisiesto

function dias {
    $diasPares = 0
    $diasImpares = 0
    anobi = [31,29,31,30,31,30,31,31,30,31,30,31]

    for ($i = 1; $i -le anobi[*]; $i++) {
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
    while ($opcion -ne "5") {
        Write-Host "`n=== MENÚ DE USUARIOS ==="
        Write-Host "1. Listar usuarios"
        Write-Host "2. Crear usuario"
        Write-Host "3. Eliminar usuario"
        Write-Host "4. Modificar nombre de usuario"
        Write-Host "0. Salir"
        $opcion = Read-Host "Elija una opción (1-5)"

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



# 6. Contraseña valida

$contra = Read-Host "Introduce una contraseña"

if ($contra.Length -ge 8 && $contra -match '[a-z]' && $contra -match '[A-Z]' && $contra -match '\d' && $contra -match '[^\w\s]') {
    Write-Host "Contraseña válida."
} else {
    Write-Host "Contraseña no válida."
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



# MENU
$opcion = 1
while ($opcion -ne '0') do {
    Clear-Host
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "     MENÚ DE EJERCICIOS" -ForegroundColor Cyan
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "1) Pedir pizza"
    Write-Host "2) Contar dias par y impar (bisiesto)"
    Write-Host "3) Menu acciones con usuarios"
    Write-Host "4) "
    Write-Host "5) "
    Write-Host "6) "
    Write-Host "7) "
    Write-Host "8) "
    Write-Host "9) "
    Write-Host "10) "
    Write-Host "11) "
    Write-Host "12) "
    Write-Host "13) "
    Write-Host "14) "
    Write-Host "15) "
    Write-Host "0) Salir"
    Write-Host "==============================" -ForegroundColor Cyan

    $opcion = Read-Host "Elige una opción (0-115)"

    switch ($opcion) {
        '1'  pizza
        '2'  dias
        '3'  menu_usuarios
        '4'  limpieza
        '5'  diskp
        '6'  contraseña
        '7'  Fibonacci
        '8'  FibonacciRecu
        '9'  monitoreo
        '10'  alertaEspacio
        '11'  copiasMasivas
        '12'  automatizarps
        '13'  barrido
        '14'  evento
        '15'  limpieza
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
