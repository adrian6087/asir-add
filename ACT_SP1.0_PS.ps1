# 1. Pedir una pizza

function pizza {
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


# 2. Calcular el número de días pares e impares que hay en un año bisiesto

function dias {
    $diasPares = 0
    $diasImpares = 0

    for ($i = 1; $i -le 366; $i++) {
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


# 4. DISCOS



# 5. Contraseña valida

$contra = Read-Host "Introduce una contraseña"

if ($contra.Length -ge 8 && $contra -match '[a-z]' && $contra -match '[A-Z]' && $contra -match '\d' && $contra -match '[^\w\s]') {
    Write-Host "Contraseña válida."
} else {
    Write-Host "Contraseña no válida."
}


# 6. Fibonnaci simple

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


# 7. Fibonacci recursivo

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


# 8. Monitorear el uso de la CPU

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


# 9. Espacio libre

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


# 10. Copias comprimidas

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


# 11. 



# 12. 



# 13. 



# 14. 



# 15. 



# MENU
$opcion = 1
while ($opcion -ne '0') do {
    Clear-Host
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "     MENÚ DE EJERCICIOS" -ForegroundColor Cyan
    Write-Host "==============================" -ForegroundColor Cyan
    Write-Host "1) Pedir pizza"
    Write-Host "2) Contar dias par y impar (bisiesto)"
    Write-Host "0) Salir"
    Write-Host "==============================" -ForegroundColor Cyan

    $opcion = Read-Host "Elige una opción (0-14)"

    switch ($opcion) {
        '1'  pizza
        '2'  dias
        '3'  menu_usuarios
        '4'  diskp
        '5'  contraseña
        '6'  Fibonacci
        '7'  FibonacciRecu
        '8'  monitoreo
        '9'  alertaEspacio
        '10'  copiasMasivas
        '11'  automatizarps
        '12'  barrido
        '13'  evento
        '14'  limpieza
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
