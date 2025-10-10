#!/bin/bash

# Funciones para cada ejercicio

# 1. Calcuar si el año es bisiesto.

bisiesto() {
    # Pedimos al usuario que introduzca un año
    read -p "Introduce un año: " ano

    
    if (( ano % 4 == 0 && ano % 100 != 0 || ano % 400 == 0 )); then
        echo "El año", $ano, "es bisiesto."
    else
        echo "El año", $ano, "no es bisiesto."
    fi
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 2. Configurar la red en base a lo que introduzca el usuario.

configurarred(){
    #Recogida de los parametros
    read -p "Introduce una ip: " IP
    read -p "Introduce una mascara: " MASCARA
    read -p "Introduce una puerta de enlace: " PUERTA_ENLACE
    read -p "Introduce una DNS: " DNS

    # Interfaz de red (puedes cambiarla si es distinta)
    INTERFAZ="enp0s3"

    echo "Configurando red..."

    # Configurar IP y máscara
    sudo ip addr flush dev $INTERFAZ
    sudo ip addr add $IP/$MASCARA dev $INTERFAZ

    # Activar la interfaz
    sudo ip link set $INTERFAZ up

    # Configurar puerta de enlace
    sudo ip route add default via $GATEWAY

    # Configurar DNS (sobrescribe resolv.conf)
    echo "nameserver $DNS" | sudo tee /etc/resolv.conf > /dev/null

    echo "Configuración aplicada. Mostrando configuración actual:"

    # Mostrar configuración actual
    ip addr show $INTERFAZ
    ip route show
    cat /etc/resolv.conf
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 3. Adivinar el numero aleatorio entre el 1-100, max 5 intentos.

adivina(){

    # Número aleatorio entre 1 y 100
    NUM=$((RANDOM % 100 + 1))
    INTENTOS=1
    MAX_INTENTOS=5

    echo "Adivina el número (entre 1 y 100). Tienes $MAX_INTENTOS intentos."

    while ( $INTENTOS -le $MAX_INTENTOS ); do
        echo -n "Intento $INTENTOS: "
        read -p "Cual crees que es el numero: " res

        if ( "$res" -eq "$NUM" ); then
           echo "¡Correcto! El numero era $res. Lo adivinaste en $INTENTOS intento(s)."
            exit 0
        elif [ "$res" -lt "$NUM" ]; then
            echo "El número es mayor."
        else
            echo "El número es menor."
        fi

        INTENTOS=$((INTENTOS + 1))
    done
    
    echo "No adivinaste. El número era: $NUM"

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 4. Buscar fichero y devolver el numero de vocales dentro.

buscar {

    # Pedir al usuario el nombre del archivo
    read -p "Introduce el nombre del archivo: " nom

    # Buscar el archivo en el directorio actual y subdirectorios
    archivo=$(find . -type f -name "$nom" 2>/dev/null | head -n 1)

    # Comprobar si el archivo existe
    if [ -z "$archivo" ]; then
        echo "Error: El archivo '$nombre' no se encontró."
    else
        # Mostrar la carpeta donde está el archivo
        carpeta=$(dirname "$archivo")
        echo "Archivo encontrado en: $carpeta"

        # Contar vocales si el archivo es legible
        if [ -r "$archivo" ]; then
            vocales=$(grep -o -i '[aeiou]' "$archivo" | wc -l)
            echo "Número de vocales en el archivo: $vocales"
        else
            echo "No se puede leer el archivo."
        fi
    fi

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 5. Contar ficheros en un directorio.

contar{

    # Pedir al usuario que introduzca un directorio
    read -p "Introduce el nombre del directorio: " dir

    # Comprobar si el directorio existe
    if [ ! -d "$dir" ]; then
        echo "Error: El directorio '$dir' no existe."
    else
        # Contar solo archivos (no subdirectorios)
        numero_ficheros=$(find "$dir" -maxdepth 1 -type f | wc -l)
        echo "En el directorio '$dir' hay $numero_ficheros fichero(s)."
    fi

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 6. Segun nombre del objeto perdir permisos en octal incluyendo los especiales.

permisosoctal {

    reap -p "Introduce la ruta absoluta del objeto: " obj

    # Comprobar si el objeto existe
    if [ ! -e "$obj" ]; then
        echo "Error: El objeto '$obj' no existe."
        exit 1
    fi

    # Obtener los permisos en formato octal (incluso con permisos especiales)
    permisos=$(stat -c "%a" "$obj")

    echo "Los permisos de '$obj' son: $permisos (en octal)"

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 7. Solicitar al usuario un número de 1 al 200 y mostrar su representación en romano.

romano {

    # Pedir al usuario un número entre 1 y 200
    read -p "Introduce un número entre 1 y 200: " num

    # Comprobar si es un número válido
    if [ "$num" -lt 1 ] || [ "$num" -gt 200 ]; then
        echo "Error: El número debe estar entre 1 y 200."
        exit 1
    fi

    # Función para convertir número a romano
    convertir_a_romano() {
        numval=$1
        numrom=""

        while [ $numval -gt 0 ]; do
            if [ $numval -ge 100 ]; then
                numrom="${numrom}C"
                numval=$((num - 100))
            elif [ $numval -ge 90 ]; then
                numrom="${numrom}XC"
                numval=$((num - 90))
            elif [ $numval -ge 50 ]; then
                numrom="${numrom}L"
                numval=$((num - 50))
            elif [ $numval -ge 40 ]; then
                numrom="${numrom}XL"
                numval=$((num - 40))
            elif [ $numval -ge 10 ]; then
                numrom="${numrom}X"
                numval=$((num - 10))
            elif [ $numval -ge 9 ]; then
                numrom="${numrom}IX"
                numval=$((num - 9))
            elif [ $numval -ge 5 ]; then
                numrom="${numrom}V"
                numval=$((num - 5))
            elif [ $numval -ge 4 ]; then
                numrom="${numrom}IV"
                numval=$((num - 4))
            else
                numrom="${numrom}I"
                numval=$((num - 1))
            fi
        done

        echo "El número $num en romano es: $numrom"
    }
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 8.

automatizar {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 9.

crear {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 10.

crear_2 {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 11.

reescribir {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 12.

contusu {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 13.

quita_blancos {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 14.

lineas {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 15.

analizar {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Menú principal
opcion = 1
while ($opcion -ne 0); do
    clear
    echo "=============================="
    echo "     MENÚ DE EJERCICIOS"
    echo "=============================="
    echo "1) Bisiesto"
    echo "2) Configurar red"
    echo "3) Adivina número"
    echo "4) Buscar fichero"
    echo "5) Contar ficheros"
    echo "6) Permisos fichero (octal)"
    echo "7) Número romano"
    echo "8) Automatizar"
    echo "9) Crear"
    echo "10) Crear 2"
    echo "11) Reescribir"
    echo "12) Contar usuarios"
    echo "13) Quitar blancos"
    echo "14) Dibujar lineas"
    echo "15) Analizar arbol"
    echo "0) Salir"
    echo "=============================="
    read -p "Elige una opción (0-15): " opcion

    case $opcion in
        1) bisiesto ;;
        2) configurarred ;;
        3) adivina ;;
        4) buscar ;;
        5) contar ;;
        6) permisosoctal ;;
        7) romano ;;
        8) automatizar ;;
        9) crear ;;
        10) crear_2 ;;
        11) reescribir ;;
        12) contusu ;;
        13) quita_blancos ;;
        14) lineas ;;
        15) analizar ;;
        0) echo "Saliendo..."; exit 0 ;;
        *) echo "Opción no válida";;
    esac
    echo ""
    read -p "Presiona Enter para continuar..."
done
