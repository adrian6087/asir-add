# Guía Básica de Bash

## Estructura de un script Bash

Un script Bash típicamente comienza con una línea shebang (#!/bin/bash) que indica el intérprete a usar. Luego puede incluir configuraciones de seguridad como set -euo pipefail, seguidas de definiciones de funciones, procesamiento de argumentos con getopts, y el cuerpo principal del script donde se ejecutan comandos y lógica. Es buena práctica organizar el código de forma modular y clara, manejando errores y validaciones para hacerlo robusto y mantenible.

```bash
#!/bin/bash

# Comentarios: todo lo que sigue a “#” en la línea se ignora

# Opciones recomendadas al inicio
set -e          # sale si un comando falla (excepto en condicionales)
set -u          # error si usas una variable no definida
set -o pipefail # si un comando en una tubería falla, el script falla
```

## Variables y expansión

En Bash, las variables se definen sin el signo $ (por ejemplo, nombre="valor"), y se accede a su contenido con $nombre. La expansión de variables permite insertar su valor en comandos, cadenas o rutas. Para asegurar una expansión segura (especialmente con espacios o caracteres especiales), se recomienda usar comillas dobles: "$variable". Bash también permite formas avanzadas de expansión, como ${#var} para longitud, ${var/pat/repl} para reemplazos, o ${var:-default} para valores por defecto si la variable no está definida.

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

Las estructuras de control en Bash permiten dirigir el flujo del script según condiciones o repeticiones. Las principales incluyen if...then...else para decisiones condicionales, y case, que es ideal para seleccionar entre múltiples opciones basadas en el valor de una variable o expresión, simplificando la escritura cuando hay varios casos posibles. Además, los bucles como for, while y until permiten repetir bloques de código bajo ciertas condiciones. Estas estructuras facilitan la automatización de tareas complejas y hacen que los scripts sean más flexibles y potentes.

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

Las funciones en Bash son bloques de código reutilizables que se definen para organizar y modularizar scripts. Se declaran con la sintaxis function nombre() { ... } o simplemente nombre() { ... }. Las funciones pueden aceptar parámetros posicionales y devolver valores mediante el código de salida o la impresión estándar. Usar funciones mejora la legibilidad, facilita el mantenimiento y permite evitar repetir código.

- Usar local para variables locales dentro de funciones (evita colisiones).
- El valor de retorno se indica con return (0–255) o usando echo/stdout para resultados.

```bash
mi_funcion() {
    local nombre="$1"
    echo "Hola, $nombre"
}

# Llamada
mi_funcion "Alice"
```

### Manejo de errores y control de salida

En Bash, el manejo de errores y el control de salida son esenciales para crear scripts robustos. Un comando exitoso devuelve un código de salida 0, mientras que cualquier error devuelve un código mayor que cero. Esto permite condicionar acciones con construcciones como comando && echo "Éxito" || echo "Fallo" o usando estructuras if. Además, se puede capturar señales externas con trap para limpiar recursos o salir ordenadamente. Configurar opciones como set -euo pipefail ayuda a que el script falle inmediatamente ante errores, evitando comportamientos inesperados.

- Un comando exitoso devuelve `0`; un error devuelve `> 0`.
- Puedes verificarlo así:

```bash
comando && echo "Éxito" || echo "Fallo"
```

- Con if:

```bash
if comando; then
  echo "OK"
else
  echo "Algo salió mal"
fi
```

- Usa trap para capturar señales y limpiar:

```bash
trap 'echo "Saliendo..."; exit' SIGINT SIGTERM
```

## Redirecciones y pipes

Las redirecciones en Bash permiten controlar hacia dónde se envía la salida de comandos o de dónde se toma la entrada. La salida estándar (stdout) se puede redirigir a un archivo usando > (sobrescribe) o >> (añade). El error estándar (stderr) se redirige con 2> y 2>>. Para combinar ambos, se usa &>. Por otro lado, los pipes (|) conectan la salida de un comando directamente como entrada de otro, facilitando la composición de comandos complejos y el procesamiento en cadena de datos.

- Salida estándar (stdout):
    - > archivo (sobrescribe) 
    - >> archivo (añade)

- Error estándar (stderr): 
    - 2> archivo 
    - 2>> archivo

- Combinar ambos: 
    - &> archivo

- Pipes: 
    - comando1 | comando2

## Lectura de comandos

La lectura de comandos en Bash permite capturar la salida de un comando y almacenarla en una variable para su posterior uso. Esto se logra utilizando la sintaxis var=$(comando), que ejecuta el comando y asigna su resultado a var. También se puede usar la forma antigua var=`comando` , aunque la primera es más moderna y recomendable. Además, para leer entrada del usuario durante la ejecución, se emplea el comando read, que captura datos desde la entrada estándar y los asigna a variables, pudiendo incluir mensajes personalizados para facilitar la interacción.

```bash
var=$(comando)  # Forma moderna
var=`comando`   # Forma antigua (no recomendada)
```

## Lectura de entrada, argumentos

En Bash, la lectura de entrada permite capturar datos del usuario durante la ejecución mediante el comando read, que almacena lo ingresado en variables. Por ejemplo, read -rp "Ingresa nombre: " nombre muestra un mensaje y espera la entrada del usuario. Para manejar opciones y argumentos pasados al script, se utiliza getopts, que facilita el procesamiento de banderas y sus valores de forma estructurada, permitiendo validar y responder a diferentes parámetros para controlar el comportamiento del script.

```bash
read -r linea
read -rp "Ingresa nombre: " nombre
```

## Uso de getopts para opciones con banderas:

getopts es una herramienta integrada en Bash que facilita el procesamiento de opciones y argumentos pasados a un script, especialmente cuando se usan banderas como -a o -b. Permite recorrer las opciones especificadas, asignar sus valores a variables y manejar errores en caso de opciones inválidas. Esto ayuda a crear scripts más flexibles y fáciles de usar.

```bash
while getopts ":a:b:h" opt; do
  case $opt in
    a) valor_a=$OPTARG ;;
    b) valor_b=$OPTARG ;;
    h) echo "Uso: $0 [-a valor] [-b valor]" ;;
    *) echo "Opción inválida"; exit 1 ;;
  esac
done
```

## Procesamiento de cadenas y sustituciones

Bash ofrece diversas herramientas para manipular cadenas directamente desde el shell. Puedes obtener la longitud de una variable con ${#var}, extraer subcadenas con ${var:inicio:longitud}, y realizar reemplazos simples, como ${var/patrón/reemplazo} para sustituir la primera aparición o ${var//patrón/reemplazo} para reemplazar todas. Además, es posible eliminar prefijos y sufijos con ${var#prefijo}, ${var##prefijo}, ${var%sufijo} y ${var%%sufijo}, permitiendo modificar y limpiar cadenas de forma eficiente sin usar comandos externos.

```bash
${#var}                     # Longitud de cadena
${var:inicio:longitud}      # Subcadena
${var/patron/reemplazo}     # Reemplazo (solo primera aparición)
${var//patron/reemplazo}    # Reemplazo (todas las apariciones)

${var#prefijo}              # Elimina menor prefijo coincidente
${var##prefijo}             # Elimina mayor prefijo coincidente
${var%sufijo}               # Elimina menor sufijo coincidente
${var%%sufijo}              # Elimina mayor sufijo coincidente
```

## Arrays

Los arrays en Bash son estructuras que permiten almacenar múltiples valores en una sola variable. Se declaran con declare -a o simplemente asignando con paréntesis, por ejemplo: arr=("uno" "dos" "tres"). Se accede a los elementos mediante índices, empezando en 0, como ${arr[0]} para el primer elemento. Puedes recorrer un array con un bucle for, obtener su longitud con ${#arr[@]}, y manipular sus elementos fácilmente, lo que facilita el manejo de listas y colecciones en scripts.

```bash
declare -a arr=("uno" "dos" "tres")

echo "${arr[0]}"    # elemento 0
echo "${arr[@]}"    # todos los elementos

# Recorrer
for e in "${arr[@]}"; do
  echo "$e"
done

# Longitud
echo "${#arr[@]}"
```

## Operaciones aritméticas

En Bash, las operaciones aritméticas se pueden realizar usando la sintaxis de doble paréntesis (( ... )), que permite realizar sumas, restas, multiplicaciones, divisiones y más, de forma sencilla y legible. Por ejemplo, (( c = a + b )) asigna a la variable c la suma de a y b. También existen comandos como expr o bc para cálculos más complejos, pero la forma con doble paréntesis es la más común y eficiente para operaciones simples dentro de scripts.

```bash
a=5
b=3
(( c = a + b ))
echo "$c"
```

## Leer y escribir archivos línea por línea

En Bash, puedes procesar archivos línea por línea utilizando un bucle while combinado con read. Esto permite leer cada línea del archivo de manera segura y eficiente, por ejemplo: while IFS= read -r linea; do ... done < archivo.txt. Esta técnica es útil para manipular o analizar el contenido de archivos grandes sin cargarlos completamente en memoria, además de permitir realizar acciones específicas por cada línea leída.

```bash
while IFS= read -r linea; do
  echo "Procesé: $linea"
done < archivo.txt
```

## Ejemplo completo pequeño

Script en Bash el cual recibe como argumento obligatorio el nombre de un archivo con la opción -f, verifica que el archivo exista y luego lee su contenido línea por línea, mostrando cada línea con un prefijo >>. Además, maneja errores y opciones inválidas, proporcionando una forma sencilla y segura de procesar archivos desde la línea de comandos.

```bash
#!/bin/bash
# Usa el intérprete bash desde la ruta del entorno

set -euo pipefail
# -e: salir si algún comando falla
# -u: salir si se usa una variable no definida
# -o pipefail: fallar si cualquier parte de un pipeline falla

# Función que muestra cómo usar el script
function uso() {
  echo "Uso: $0 -f <archivo>"  # $0 es el nombre del script
  exit 1  # Salida con error
}

file=""  # Inicializa la variable 'file' vacía

# Procesamiento de opciones con getopts
while getopts ":f:h" opt; do
  case $opt in
    f) file=$OPTARG ;;  # Guarda el argumento de -f en la variable 'file'
    h) uso ;;           # Si se pasa -h, muestra ayuda
    *) uso ;;           # Cualquier otra opción inválida, también muestra ayuda
  esac
done

# Verifica si no se proporcionó un archivo
if [[ -z "$file" ]]; then
  uso  # Muestra ayuda y termina
fi

# Verifica si el archivo especificado no existe
if [[ ! -f "$file" ]]; then
  echo "El archivo $file no existe"
  exit 1  # Termina con error
fi

# Lee el archivo línea por línea
while IFS= read -r line; do
  echo ">> $line"  # Imprime cada línea con prefijo ">>"
done < "$file"  # Redirige la entrada del bucle al archivo especificado
```

![Deus me livre](https://cdn.pixabay.com/photo/2017/02/19/20/06/prayer-2080843_960_720.jpg)
