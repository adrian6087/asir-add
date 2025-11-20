#!/bin/bash

# Define el nombre del archivo donde se guardarán los resultados.
ARCHIVO_SALIDA="errores_log_filtrados.txt"

# Borra el contenido del archivo de salida anterior o crea uno nuevo.
> $ARCHIVO_SALIDA

# Define el directorio que vamos a revisar.
DIR_LOG="/var/log"

echo "Buscando errores ('error' o 'fail') en los archivos de $DIR_LOG..."
echo "---" >> $ARCHIVO_SALIDA

# Inicia un recorrido por cada archivo en el directorio de logs.
for log_file in $DIR_LOG/*; do

    # Comprueba si el elemento actual es un archivo real.
    if [ -f "$log_file" ]; then

        # Busca las palabras clave "error" o "fail" en el archivo.
        grep -i -E "error|fail" "$log_file" 2>/dev/null

        # Si el comando anterior (grep) encontró algo (código 0), ejecuta el siguiente bloque.
        if [ $? -eq 0 ]; then

            # Escribe en el archivo de salida el nombre del archivo de log que contiene los errores.
            echo "ERRORES ENCONTRADOS EN: $log_file" >> $ARCHIVO_SALIDA
            echo "--------------------------------------------------------" >> $ARCHIVO_SALIDA

            # Vuelve a buscar, redirigiendo también los errores de permisos para mantener la terminal limpia.
            grep -i -E "error|fail" "$log_file" 2>/dev/null >> $ARCHIVO_SALIDA

            # Añade una línea en blanco para separar los resultados del siguiente archivo.
            echo "" >> $ARCHIVO_SALIDA
        fi
    fi
done

echo "---" >> $ARCHIVO_SALIDA
echo "Busqueda terminada. Los resultados se guardaron en: $ARCHIVO_SALIDA"
