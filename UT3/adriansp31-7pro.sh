#!/bin/bash
# Indica que usaremos Bash para ejecutar el script.

# Guarda el nombre del archivo de la lista.
LISTA_PROGRAMAS="programas.txt"

# --- Comprobación Inicial ---

# Pregunta: ¿El archivo de lista NO existe?
if [ ! -f "$LISTA_PROGRAMAS" ]; then
    # Si no existe, muestra un error.
    echo "Error: El archivo '$LISTA_PROGRAMAS' no se encuentra en el directorio actual."
    # Detiene el script.
    exit 1
fi

# Muestra mensajes de inicio.
echo "Iniciando la desinstalación de programas listados en '$LISTA_PROGRAMAS'."
echo "Se requerirá tu contraseña de administrador (sudo)."

# --- Desinstalación ---

# Empieza a leer el archivo línea por línea.
while IFS= read -r PROGRAMA
do
    # Quita espacios extra del nombre del programa.
    PROGRAMA=$(echo "$PROGRAMA" | xargs)

    # Pregunta: ¿El nombre del programa NO está vacío?
    if [ -n "$PROGRAMA" ]; then
        echo "---"
        echo "Intentando desinstalar: $PROGRAMA"
        
        # Desinstala el programa y sus archivos de configuración (-y confirma la acción).
        sudo apt purge -y "$PROGRAMA"
        
        # Pregunta: ¿El comando anterior funcionó correctamente (código 0)?
        if [ $? -eq 0 ]; then
            # Muestra éxito.
            echo "'$PROGRAMA' desinstalado con éxito (o no estaba instalado)."
        else
            # Muestra advertencia si falló.
            echo "Hubo un error al intentar desinstalar '$PROGRAMA'. Revisa el nombre."
        fi
    fi
done < "$LISTA_PROGRAMAS" # Le dice al bucle 'while' qué archivo leer.

# --- Limpieza Final ---

echo "---"
echo "Limpieza final (eliminación de dependencias innecesarias)..."
# Elimina paquetes que ya no sirven para nada.
sudo apt autoremove -y

# Muestra que ha terminado.
echo "---"
echo "Proceso completado."
