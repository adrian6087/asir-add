# Recibimos los parámetros.
param( [string]$accion, [string]$par2, [string]$par3, [switch]$DryRun )

# --- OPCIÓN G: CREAR GRUPO ---
if ($accion -eq "G") {
    $nombreGrupo = Read-Host "Escribe el nombre del grupo"
    
    # MODO SIMULACIÓN (DryRun)
    if ($DryRun) {
        Write-Host "[SIMULACIÓN] 1. Buscaría si existe el grupo '$nombreGrupo'."
        Write-Host "[SIMULACIÓN] 2. Si no existe, crearía el grupo con:"
        Write-Host "             - Nombre: $nombreGrupo"
        Write-Host "             - Ámbito: $par2"
        Write-Host "             - Tipo:   $par3"
    } 
    # MODO REAL
    else {
        if (Get-ADGroup -Filter "Name -eq '$nombreGrupo'") {
            Write-Host "El grupo ya existe."
        } else {
            New-ADGroup -Name $nombreGrupo -GroupScope $par2 -GroupCategory $par3
            Write-Host "Grupo creado correctamente."
        }
    }
} 

# --- OPCIÓN U: CREAR USUARIO ---
elseif ($accion -eq "U") {
    
    # Generamos contraseña aleatoria compleja
    $pass = -join ((48..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
    
    # MODO SIMULACIÓN (DryRun)
    if ($DryRun) {
        Write-Host "[SIMULACIÓN] 1. Comprobaría si el usuario '$par2' existe."
        Write-Host "[SIMULACIÓN] 2. Generaría la contraseña segura: $pass"
        Write-Host "[SIMULACIÓN] 3. Crearía el usuario en la ruta: $par3"
    } 
    # MODO REAL
    else {
        if (Get-ADUser -Filter "Name -eq '$par2'") {
            Write-Host "El usuario ya existe."
        } else {
            $passSegura = ConvertTo-SecureString $pass -AsPlainText -Force
            
            # Usamos Try/Catch para evitar errores rojos si la ruta está mal
            try {
                New-ADUser -Name $par2 -AccountPassword $passSegura -Path $par3 -Enabled $true -ErrorAction Stop
                Write-Host "Usuario creado correctamente."
                Write-Host "Su contraseña es: $pass"
            } catch {
                Write-Host "AVISO: No se pudo crear. Verifica que la ruta ($par3) sea correcta."
            }
        }    
    }
}

# --- OPCIÓN M: MODIFICAR ---
elseif ($accion -eq "M") {
    
    # Validamos requisitos de contraseña antes de hacer nada
    if ($par2.Length -ge 8 -and $par2 -match '[A-Z]' -and $par2 -match '\d') {
        
        $usu = Read-Host "Usuario a modificar"

        # MODO SIMULACIÓN (DryRun)
        if ($DryRun) {
            Write-Host "[SIMULACIÓN] 1. Buscaría al usuario '$usu'."
            Write-Host "[SIMULACIÓN] 2. Cambiaría su contraseña a: $par2"
            Write-Host "[SIMULACIÓN] 3. Cambiaría su estado a: $par3"
        } 
        # MODO REAL
        else {
            $passSegura = ConvertTo-SecureString $par2 -AsPlainText -Force
            
            try {
                Set-ADAccountPassword -Identity $usu -NewPassword $passSegura -Reset -ErrorAction Stop
                
                if ($par3 -eq "Enable") { Enable-ADAccount -Identity $usu }
                else { Disable-ADAccount -Identity $usu }
                
                Write-Host "Contraseña y estado actualizados."
            } catch {
                Write-Host "Error: No se encontró el usuario '$usu'."
            }
        }
    } else {
        Write-Host "Error: La contraseña no cumple los requisitos."
    }
}

# --- OPCIÓN AG: ASIGNAR A GRUPO ---
elseif ($accion -eq "AG") {
    
    # MODO SIMULACIÓN (DryRun)
    if ($DryRun) {
        Write-Host "[SIMULACIÓN] 1. Verificaría que existen usuario '$par2' y grupo '$par3'."
        Write-Host "[SIMULACIÓN] 2. Ejecutaría: Add-ADGroupMember -Identity $par3 -Members $par2"
    } 
    # MODO REAL
    else {
        $existeUsu = Get-ADUser -Filter "Name -eq '$par2'"
        $existeGrp = Get-ADGroup -Filter "Name -eq '$par3'"

        if ($existeUsu -and $existeGrp) {
            Add-ADGroupMember -Identity $par3 -Members $par2
            Write-Host "Usuario añadido al grupo."
        } else {
            Write-Host "Error: Falla el usuario o el grupo."
        }
    }
}

# --- OPCIÓN LIST: LISTAR ---
elseif ($accion -eq "LIST") {
    
    # MODO SIMULACIÓN (DryRun)
    if ($DryRun) {
        Write-Host "[SIMULACIÓN] Se mostraría la lista de: $par2"
        if ($par3) { Write-Host "[SIMULACIÓN] Aplicando filtro de UO: $par3" }
        else { Write-Host "[SIMULACIÓN] Buscando en todo el dominio." }
    } 
    # MODO REAL
    else {
        if ($par2 -eq "Usuarios") {
            if ($par3) { Get-ADUser -Filter * -SearchBase $par3 | Select Name }
            else       { Get-ADUser -Filter * | Select Name }
        } 
        elseif ($par2 -eq "Grupos") {
            if ($par3) { Get-ADGroup -Filter * -SearchBase $par3 | Select Name }
            else       { Get-ADGroup -Filter * | Select Name }
        }
        elseif ($par2 -eq "Ambos") {
            Write-Host "--- USUARIOS ---"
            Get-ADUser -Filter * | Select Name
            Write-Host "--- GRUPOS ---"
            Get-ADGroup -Filter * | Select Name
        }
    }
} 

# --- MENÚ DE AYUDA ---
else {
    Write-Host "Faltan datos. Usa uno de estos ejemplos:"
    Write-Host "NOTA: Añade -DryRun al final para simular sin hacer cambios."
    Write-Host " "
    Write-Host "1. Crear Grupo:   .\magdieladrian.ps1 -accion G -par2 Global -par3 Security"
    Write-Host "2. Crear Usuario: .\magdieladrian.ps1 -accion U -par2 Nombre -par3 'OU=Ventas,DC=midominio'"
    Write-Host "3. Modificar:     .\magdieladrian.ps1 -accion M -par2 ClaveNueva1 -par3 Enable"
    Write-Host "4. Asignar:       .\magdieladrian.ps1 -accion AG -par2 Usuario -par3 Grupo"
    Write-Host "5. Listar:        .\magdieladrian.ps1 -accion LIST -par2 Usuarios"
}
