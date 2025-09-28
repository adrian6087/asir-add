#!/bin/bash

# Funciones para cada ejercicio
bisiesto() {
read -p "Introduce un año: " ano

if (( ano % 4 == 0 && ano % 100 != 0 || ano % 400 == 0 )); then
    echo "El año", $ano, "es bisiesto."
else
    echo "El año", $ano, "no es bisiesto."
fi
}

configurarred(){
#Recogida de los parametros
read -p "Introduce una ip: " IP
read -p "Introduce una mascara: " MASCARA
read -p "Introduce una puerta de enlace: " PUERTA_ENLACE
read -p "Introduce una DNS: " DNS

# Interfaz de red (puedes cambiarla si es distinta)
INTERFAZ="eth0"

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

adivina(){
#!/bin/bash

# Número aleatorio entre 1 y 100
NUM=$((RANDOM % 100 + 1))
INTENTOS=1
MAX_INTENTOS=5

echo "Adivina el número (entre 1 y 100). Tienes $MAX_INTENTOS intentos."

while ( $INTENTOS -le $MAX_INTENTOS ); do
    echo -n "Intento $INTENTOS: "
    read RESPUESTA

    if ( "$RESPUESTA" -eq "$NUM" ); then
        echo "¡Correcto! Adivinaste en $INTENTOS intento(s)."
        exit 0
    elif [ "$RESPUESTA" -lt "$NUM" ]; then
        echo "El número es mayor."
    else
        echo "El número es menor."
    fi

    INTENTOS=$((INTENTOS + 1))
done

echo "No adivinaste. El número era: $NUM"
}

# Menú principal
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
    echo
    read -p "Presiona Enter para continuar..."
done
