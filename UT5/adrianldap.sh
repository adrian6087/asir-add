#!/bin/bash

# Detectamos el dominio principal automaticamente consultando la raiz de LDAP
DOMINIO=$(ldapsearch -x -s base -b "" namingContexts -LLL | grep namingContexts | awk '{print $2}')

opcion="1"
while [ "$opcion" != "0" ]; do
    clear
    echo "==================================="
    echo "             MENU LDAP             "
    echo "==================================="
    echo "1. Eliminar correo"
    echo "2. Modificar correo"
    echo "3. Buscar usuarios"
    echo "0. Salir"
    echo "==================================="
    read -p "Elige una opcion: " opcion

    if [ "$opcion" == "1" ]; then
        echo ""
        echo "--- ELIMINAR CORREO ---"
        # Pedimos los datos necesarios por pantalla
        read -p "UID del usuario: " uid
        read -p "OU (Alumnado o Profesorado): " ou

        # Iniciamos el archivo temporal usando la variable DOMINIO
        echo "dn: uid=$uid,ou=$ou,$DOMINIO" > temp.ldif
        # Anadimos las instrucciones para borrar el atributo mail
        echo "changetype: modify" >> temp.ldif
        echo "delete: mail" >> temp.ldif

        echo ""
        # Aplicamos los cambios y usamos la variable DOMINIO para el admin
        ldapmodify -x -D "cn=admin,$DOMINIO" -W -f temp.ldif

        echo ""
        read -p "Pulsa Enter para continuar..."

    elif [ "$opcion" == "2" ]; then
        echo ""
        echo "--- MODIFICAR CORREO ---"
        # Pedimos los datos del usuario y el correo nuevo
        read -p "UID del usuario: " uid
        read -p "OU (Alumnado o Profesorado): " ou
        read -p "Nuevo correo: " correo

        # Sobrescribimos el temporal con la variable DOMINIO
        echo "dn: uid=$uid,ou=$ou,$DOMINIO" > temp.ldif
        # Usamos 'replace' para cambiar el correo actual por el nuevo
        echo "changetype: modify" >> temp.ldif
        echo "replace: mail" >> temp.ldif
        echo "mail: $correo" >> temp.ldif

        echo ""
        # Inyectamos las modificaciones en la base de datos
        ldapmodify -x -D "cn=admin,$DOMINIO" -W -f temp.ldif

        echo ""
        read -p "Pulsa Enter para continuar..."

    elif [ "$opcion" == "3" ]; then
        echo ""
        echo "--- BUSCAR USUARIOS ---"
        # Damos la opcion de buscar uno especifico o ver la lista entera
        read -p "Escribe un UID (o pulsa Enter para ver TODOS): " uid
        echo ""

        if [ "$uid" == "" ]; then
            # Si no escribe nada, listamos en el DOMINIO detectado
            ldapsearch -x -b "$DOMINIO" "(objectClass=inetOrgPerson)" cn mail
        else
            # Si escribe un UID, buscamos su informacion en el DOMINIO
            ldapsearch -x -b "$DOMINIO" "(uid=$uid)"
        fi

        echo ""
        read -p "Pulsa Enter para continuar..."

    elif [ "$opcion" == "0" ]; then
        clear
        echo "Saliendo del script..."
    else
        clear
        echo "Opcion no valida."
        echo ""
        read -p "Pulsa Enter para continuar..."
    fi
done
