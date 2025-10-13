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

buscar() {

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

contar() {

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

permisosoctal() {

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

romano() {

    # Pedir al usuario un número entre 1 y 200
    read -p "Introduce un número entre 1 y 200: " num

    # Comprobar si es un número válido
    if [ "$num" -lt 1 ] || [ "$num" -gt 200 ]; then
        echo "Error: El número debe estar entre 1 y 200."
        exit 1
    fi

    # Función para convertir número a romano
    convrom($num) {
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

# 8. Crear usuarios y carpetas personales según los archivos en /mnt/usuarios y eliminar cada archivo tras procesarlo; si no hay archivos, mostrar "listado vacío".

automatizar() {

    # Comprobar si el directorio /mnt/usuarios está vacío
    if [ -z "$(ls -A /mnt/usuarios 2>/dev/null)" ]; then
        echo "Listado vacío"
        exit 0
    fi

    # Recorrer cada archivo en /mnt/usuarios
    for archivo in /mnt/usuarios/*; do
        if [ -f "$archivo" ]; then
            # Obtener el nombre del archivo (sin ruta)
            nombre_usuario=$(basename "$archivo")

            # Crear el usuario con home
            echo "Creando usuario: $nombre_usuario"
            useradd -m "$nombre_usuario" 2>/dev/null

            # Comprobar si el usuario se creó correctamente
            if id "$nombre_usuario" &>/dev/null; then
                # Leer cada línea del archivo y crear carpetas en su directorio personal
                while IFS= read -r linea; do
                    # Comprobar que la línea no esté vacía
                    if [ -n "$linea" ]; then
                        mkdir -p "/home/$nombre_usuario/$linea"
                        echo "Carpeta creada: /home/$nombre_usuario/$linea"
                    fi
                done < "$archivo"

                # Eliminar el archivo después de procesarlo
                rm "$archivo"
                echo "Archivo eliminado: $archivo"
            else
                echo "Error: No se pudo crear el usuario $nombre_usuario"
            fi
        fi
    done

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 9. Crear un fichero en el directorio actual con nombre y tamaño dados (parametros), si faltan, usar por defecto "fichero_vacio" y 1.024KB.

crear() {

    # Si no se pasan parámetros
    if [ $# -eq 0 ]; then
        nom="fichero_vacio"
        tam=1024
    # Si se pasa un parámetro
    elif [ $# -eq 1 ]; then
        nom="$1"
        tam=1024
    # Si se pasan dos parámetros
    elif [ $# -eq 2 ]; then
        nom="$1"
        tam="$2"
    else
        echo "Uso: $0 [nombre_fichero] [tamaño_en_KB]"
        exit 1
    fi

    # Crear el archivo con el tamaño indicado en KB
    dd if=/dev/zero of="$nom" bs=1K count="$tam" 2>/dev/null

    echo "Fichero '$nom' creado con $tam KB."

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 10.Crear un fichero con nombre y tamaño dados (parametros); si el nombre ya existe, añadir un número del 1-9 al final; si todos existen, mostrar un aviso y no crear nada.

crear_2() {

    # Si no se pasan parámetros
    if [ $# -eq 0 ]; then
        nom="fichero_vacio"
        tam=1024
    # Si se pasa un parámetro
    elif [ $# -eq 1 ]; then
        nom="$1"
        tam=1024
    # Si se pasan dos parámetros
    elif [ $# -eq 2 ]; then
        nom="$1"
        tam="$2"
    else
        echo "Uso: $0 [nombre_fichero] [tamaño_en_KB]"
        exit 1
    fi

    # Comprobar si el archivo ya existe
    if [ -e "$nom" ]; then
        encontrado=0
        for i in {1..9}; do
            nuevo_nombre="${nom}${i}"
            if [ ! -e "$nuevo_nombre" ]; then
                nom="$nuevo_nombre"
                encontrado=1
                break
            fi
        done

        if [ $encontrado -eq 0 ]; then
            echo "Ya existen archivos desde $nom1 hasta $nom9. No se creará ningún archivo."
            return 1
        fi
    fi

    # Crear el archivo con el tamaño indicado en KB
    dd if=/dev/zero of="$nom" bs=1K count="$tam" 2>/dev/null

    echo "Fichero '$nom' creado con $tam KB."

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 11. Dar una palabra como parámetro y mostrarla por pantalla reemplazando vocales: a→1, e→2, i→3, o→4, u→5.

reescribir() {

    # Verificar que se haya pasado un parámetro
    if [ -z "$1" ]; then
        echo "Uso: $0 <palabra>"
        exit 1
    fi

    palabra="$1"

    # Sustituir las vocales por números
    palabra=$(echo "$palabra" | tr 'a' '1')
    palabra=$(echo "$palabra" | tr 'e' '2')
    palabra=$(echo "$palabra" | tr 'i' '3')
    palabra=$(echo "$palabra" | tr 'o' '4')
    palabra=$(echo "$palabra" | tr 'u' '5')

    # Mostrar la palabra modificada
    echo "$palabra"

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 12. Contar cuántos usuarios reales tiene la carpeta /home, permitir elegir uno y realiza una copia de su directorio en /home/copiaseguridad/nombreusuario_fecha.

contusu() {

    # Directorio donde se guardarán las copias
    backup_dir="/home/copiaseguridad"

    # Crear directorio de copias si no existe
    mkdir -p "$backup_dir"

    # Obtener usuarios con directorio en /home
    usuarios=($(ls /home | grep -v "lost+found"))

    # Mostrar número de usuarios
    echo "Número de usuarios con directorio en /home: ${#usuarios[@]}"

    # Mostrar lista de usuarios
    echo "Usuarios disponibles:"
    for i in "${!usuarios[@]}"; do
        echo "$((i+1)). ${usuarios[i]}"
    done

    # Pedir al usuario que elija uno
    read -p "Selecciona un usuario por número: " num

    # Verificar que la selección sea válida
    if [[ $num -ge 1 && $num -le ${#usuarios[@]} ]]; then
        usuario="${usuarios[$((num-1))]}"
    else
        echo "Selección inválida."
        exit 1
    fi

    # Fecha actual
    fecha=$(date +%Y%m%d_%H%M%S)

    # Ruta de la copia de seguridad
    destino="$backup_dir/${usuario}_$fecha"

    # Realizar la copia de seguridad
    tar -czf "$destino.tar.gz" -C /home "$usuario"

    # Confirmar
    echo "Copia de seguridad creada en: $destino.tar.gz"

}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 13. Renombrar automáticamente todos los ficheros del directorio actual, reemplazando los espacios en blanco en sus nombres por guiones bajos (_).

quita_blancos() {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 14. Validar tres parámetros (carácter, número 1–60, número 1–10) y dibujar en pantalla el número de líneas indicado, cada una con el carácter dado repetido según la longitud especificada.

lineas() {



}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 15. Analizar un directorio (incluyendo subdirectorios) indicado como parámetro, contando cuántos archivos hay de cada una de las extensiones especificadas en los argumentos.

analizar() {



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
