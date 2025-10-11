# Guía Básica de Bash

## Introducción

Bash (Bourne Again SHell) es un intérprete de comandos y lenguaje de scripting muy usado en sistemas Unix / Linux.  
Con Bash puedes automatizar tareas del sistema, manipular archivos, ejecutar programas, procesar texto, etc.

## Estructura de un script Bash

```bash
#!/bin/bash

# Comentarios: todo lo que sigue a “#” en la línea se ignora

# Opciones recomendadas al inicio
set -e          # sale si un comando falla (excepto en condicionales)
set -u          # error si usas una variable no definida
set -o pipefail # si un comando en una tubería falla, el script falla
```

## Variables y expansión

```bash
# Asignación (sin espacios alrededor del "="):
mi_var="Hola Mundo"

# Uso de variables:
echo "$mi_var"

# Concatenación implícita:
otra="Mundo"
saludo="Hola $otra"

# Variables especiales:
$0  # nombre del script
$1, $2 …  # argumentos posicionales
$#  # número de argumentos
$@  # todos los argumentos (como lista)
$?  # código de retorno del último comando
$$  # PID del proceso actual
```

## Estructuras de control

### Condicional if

```bash
if [[ condición ]]; then
    # código si true
elif [[ otra_condición ]]; then
    # otro bloque
else
    # código si nada anterior
fi
```

#### Ejemplos:

```bash
[[ -f archivo.txt ]]   # verdadero si archivo.txt existe y es archivo regular
[[ -d carpeta ]]       # verdadero si “carpeta” existe y es directorio
[[ -z "$var" ]]        # verdadero si var es cadena vacía
[[ "$a" -lt "$b" ]]    # comparación numérica (menor que)
[[ "$a" = "$b" ]]      # comparación de cadenas
```

### Bucle for

```bash
for var in a b c; do
    echo "$var"
done
```

#### Iterar sobre archivos:

```bash
for file in *.txt; do
    echo "Procesando $file"
done
```

### Bucle while

```bash
while [[ condición ]]; do
    # código
    :
done
```

### Bucle until

```bash
until [[ condición ]]; do
    # se ejecuta mientras la condición sea falsa
done
```

### case

```bash
case "$var" in
    pattern1)
        # bloque para pattern1
        ;;
    pattern2|pattern3)
        # bloque para pattern2 o pattern3
        ;;
    *)
        # bloque por defecto
        ;;
esac
```

## Funciones

Usar local para variables locales dentro de funciones (evita colisiones).
El valor de retorno se indica con return (0–255) o usando echo/stdout para resultados.

```bash
mi_funcion() {
    local nombre="$1"
    echo "Hola, $nombre"
}

# Llamada
mi_funcion "Alice"
```


Manejo de errores y control de salida Un comando exitoso devuelve 0; un error devuelve > 0. Puedes verificarlo así: comando && echo "Éxito" || echo "Fallo" O con if: if comando; then echo "OK" else echo "Algo salió mal" fi Usa trap para capturar señales y limpiar: trap 'echo "Saliendo..."; exit' SIGINT SIGTERM Redirecciones y pipes Salida estándar (stdout): > archivo (sobrescribe), >> archivo (añade) Error estándar (stderr): 2> archivo, 2>> archivo Combinar ambos: &> archivo Tubos (pipes): comando1 | comando2 Lectura de comandos: var=$(comando) o var=comando (la primera forma es más moderna) Lectura de entrada, argumentos read -r linea read -rp "Ingresa nombre: " nombre # Usar getopts para opciones con banderas: while getopts ":a:b:h" opt; do case $opt in a) valor_a=$OPTARG ;; b) valor_b=$OPTARG ;; h) echo "Uso: $0 [-a valor] [-b valor]" ;; *) echo "Opción inválida"; exit 1 ;; esac done Procesamiento de cadenas y sustituciones # Longitud de cadena: ${#var} # Subcadena: ${var:inicio:longitud} # Reemplazo: ${var/patron/reemplazo} # solo primera aparición ${var//patron/reemplazo} # todas las apariciones # Eliminación de prefijo/sufijo: ${var#prefijo} # elimina el menor prefijo coincidente ${var##prefijo} # el mayor prefijo coincidente ${var%sufijo} # elimina el menor sufijo coincidente ${var%%sufijo} # el mayor sufijo coincidente Arrays # Declaración declare -a arr=("uno" "dos" "tres") # Acceso echo "${arr[0]}" # elemento 0 echo "${arr[@]}" # todos los elementos # Recorrer for e in "${arr[@]}"; do echo "$e" done # Longitud echo "${#arr[@]}" Operaciones aritméticas # Uso de double parentheses: a=5 b=3 (( c = a + b )) echo "$c" # Otra forma: “expr” o “bc” (menos usada) Leer y escribir archivos línea por línea while IFS= read -r linea; do echo "Procesé: $linea" done < archivo.txt Ejemplo completo pequeño #!/usr/bin/env bash set -euo pipefail function uso() { echo "Uso: $0 -f <archivo>" exit 1 } file="" while getopts ":f:h" opt; do case $opt in f) file=$OPTARG ;; h) uso ;; *) uso ;; esac done if [[ -z "$file" ]]; then uso fi if [[ ! -f "$file" ]]; then echo "El archivo $file no existe" exit 1 fi while IFS= read -r line; do echo ">> $line" done < "$file"
