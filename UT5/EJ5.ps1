Import-Module ActiveDirectory

$dominio = (Get-ADDomain).DistinguishedName

$opcion = "1"
while ($opcion -ne "0") {
    Clear-Host
    Write-Host "--- MENU GESTION DE DOMINIO ---"
    Write-Host "1. Mostrar informacion del dominio"
    Write-Host "2. Crear Unidad Organizativa"
    Write-Host "3. Ver miembros de una OU"
    Write-Host "4. Crear grupo"
    Write-Host "5. Crear usuario (con grupo y cambio de pass)"
    Write-Host "0. Salir"
    
    $opcion = Read-Host "Elige una opcion"

    if ($opcion -eq "1") {
        # Opcion 1: Mostrar datos del equipo, dominio y contar objetos
        Write-Host "Nombre del Equipo: $env:COMPUTERNAME"
        
        # Como ahora el dominio es automatico, sacamos el nombre de red (ej. adrian.aws)
        $nombreRed = (Get-ADDomain).Name
        Write-Host "Dominio: $nombreRed"
        
        # Guardamos en variables la cantidad (.Count) de cada tipo de objeto
        $ous = (Get-ADOrganizationalUnit -Filter *).Count
        $grupos = (Get-ADGroup -Filter *).Count
        $usuarios = (Get-ADUser -Filter *).Count
        
        Write-Host "Total OUs: $ous"
        Write-Host "Total Grupos: $grupos"
        Write-Host "Total Usuarios: $usuarios"
    }
    
    elseif ($opcion -eq "2") {
        # Opcion 2: Crear una OU nueva en la raiz del dominio
        $nombreOU = Read-Host "Dime el nombre de la OU"
        
        New-ADOrganizationalUnit -Name $nombreOU -Path $dominio
        Write-Host "OU $nombreOU creada correctamente."
    }
    
    elseif ($opcion -eq "3") {
        # Opcion 3: Mostrar los usuarios guardados dentro de una OU
        $nombreOU = Read-Host "Dime de que OU quieres ver los usuarios"
        $rutaOU = "OU=$nombreOU,$dominio"
        
        Get-ADUser -Filter * -SearchBase $rutaOU | Select-Object Name
    }
    
    elseif ($opcion -eq "4") {
        # Opcion 4: Crear un grupo de seguridad global
        $nombreGrupo = Read-Host "Dime el nombre del grupo"
        $nombreOU = Read-Host "Dime en que OU lo guardo"
        $rutaOU = "OU=$nombreOU,$dominio"
        
        New-ADGroup -Name $nombreGrupo -GroupCategory Security -GroupScope Global -Path $rutaOU
        Write-Host "Grupo $nombreGrupo creado."
    }
    
    elseif ($opcion -eq "5") {
        # Opcion 5: Crear usuario con todos los requisitos
        $nombre = Read-Host "Nombre completo del usuario"
        $login = Read-Host "Login (ej. nombre.apellido)"
        $passPlana = Read-Host "Contrasena temporal"
        $nombreGrupo = Read-Host "Grupo al que anadirlo"
        $nombreOU = Read-Host "OU donde crearlo"
        
        # Convertimos la contrasena texto plano a segura
        $passSegura = ConvertTo-SecureString $passPlana -AsPlainText -Force
        $rutaOU = "OU=$nombreOU,$dominio"
        
        # Creamos el usuario obligando al cambio de contrasena (-ChangePasswordAtLogon $true)
        New-ADUser -Name $nombre -SamAccountName $login -AccountPassword $passSegura -Path $rutaOU -Enabled $true -ChangePasswordAtLogon $true
        
        # Lo metemos en el grupo que hemos indicado
        Add-ADGroupMember -Identity $nombreGrupo -Members $login
        Write-Host "Usuario creado, unido al grupo y forzado a cambiar contrasena."
    }

    if ($opcion -ne "0") {
        Read-Host "Pulsa Enter para volver al menu..."
    }
}
