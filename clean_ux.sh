#!/bin/bash

# Banner interactivo
banner() {
    clear
    echo -e "\e[1;36m"
    echo " ██████╗██╗     ███████╗ █████╗ ███╗   ██╗      ██╗   ██╗██╗  ██╗"
    echo "██╔════╝██║     ██╔════╝██╔══██╗████╗  ██║      ██║   ██║╚██╗██╔╝"
    echo "██║     ██║     █████╗  ███████║██╔██╗ ██║█████╗██║   ██║ ╚███╔╝ "
    echo "██║     ██║     ██╔══╝  ██╔══██║██║╚██╗██║╚════╝██║   ██║ ██╔██╗ "
    echo "╚██████╗███████╗███████╗██║  ██║██║ ╚████║      ╚██████╔╝██╔╝ ██╗"
    echo " ╚═════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝       ╚═════╝ ╚═╝  ╚═╝"
    echo -e "                             \e[2mby ENDE\e[0m\n"
}

banner

echo "Iniciando limpieza del sistema..."

echo "Niveles de limpieza disponibles:"
echo "  1) Básica     - Limpiar caché de paquetes y archivos temporales de paquetes."
echo "  2) Intermedia - Todo lo anterior + eliminar paquetes innecesarios y logs antiguos."
echo "  3) Profunda   - Todo lo anterior + limpiar /tmp y vaciar la papelera."
echo "  x) Salir      - Cancelar y salir sin hacer nada."
echo -n "Selecciona el nivel de limpieza (1/2/3/x): "
read -r nivel
if [[ "$nivel" == "x" || "$nivel" == "X" ]]; then
    echo "Operación cancelada por el usuario."
    exit 0
fi

# Mostrar resumen de acciones según el nivel y listar archivos a eliminar
case "$nivel" in
    1)
        resumen="- Limpiar caché de paquetes\n- Limpiar archivos temporales de paquetes"
        echo -e "\nArchivos de caché de paquetes a eliminar (apt):"
        if command -v apt &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/apt/archives/ -type f)
        elif command -v dnf &> /dev/null; then
            echo "Archivos de caché de dnf:"
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/dnf/ -type f)
        fi
        ;;
    2)
        resumen="- Limpiar caché de paquetes\n- Limpiar archivos temporales de paquetes\n- Eliminar paquetes innecesarios\n- Eliminar logs antiguos (>30 días)"
        echo -e "\nArchivos de caché de paquetes a eliminar (apt):"
        if command -v apt &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/apt/archives/ -type f)
        elif command -v dnf &> /dev/null; then
            echo "Archivos de caché de dnf:"
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/dnf/ -type f)
        fi
        echo -e "\nLogs antiguos (>30 días) a eliminar:"
        if command -v apt &> /dev/null || command -v dnf &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[1;33m$file\e[0m"; done < <(sudo find /var/log -name "*.log" -mtime +30)
        fi
        echo -e "\nPaquetes innecesarios a eliminar:"
        if command -v apt &> /dev/null; then
            apt-mark showauto | xargs apt-cache show 2>/dev/null | grep -E '^Package:' | awk '{print $2}' | while IFS= read -r pkg; do echo -e "\e[1;33m$pkg\e[0m"; done
        elif command -v dnf &> /dev/null; then
            dnf repoquery --extras | while IFS= read -r pkg; do echo -e "\e[1;33m$pkg\e[0m"; done
        fi
        ;;
    3)
        resumen="- Limpiar caché de paquetes\n- Limpiar archivos temporales de paquetes\n- Eliminar paquetes innecesarios\n- Eliminar logs antiguos (>30 días)\n- Limpiar /tmp (archivos no accedidos en 10 días)\n- Vaciar la papelera"
        echo -e "\nArchivos de caché de paquetes a eliminar (apt):"
        if command -v apt &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/apt/archives/ -type f)
        elif command -v dnf &> /dev/null; then
            echo "Archivos de caché de dnf:"
            while IFS= read -r file; do echo -e "\e[0;32m$file\e[0m"; done < <(find /var/cache/dnf/ -type f)
        fi
        echo -e "\nLogs antiguos (>30 días) a eliminar:"
        if command -v apt &> /dev/null || command -v dnf &> /dev/null; then
            while IFS= read -r file; do echo -e "\e[1;33m$file\e[0m"; done < <(sudo find /var/log -name "*.log" -mtime +30)
        fi
        echo -e "\nPaquetes innecesarios a eliminar:"
        if command -v apt &> /dev/null; then
            apt-mark showauto | xargs apt-cache show 2>/dev/null | grep -E '^Package:' | awk '{print $2}' | while IFS= read -r pkg; do echo -e "\e[1;33m$pkg\e[0m"; done
        elif command -v dnf &> /dev/null; then
            dnf repoquery --extras | while IFS= read -r pkg; do echo -e "\e[1;33m$pkg\e[0m"; done
        fi
        echo -e "\nArchivos en /tmp a eliminar (no accedidos en 10 días):"
        while IFS= read -r file; do echo -e "\e[1;31m$file\e[0m"; done < <(sudo find /tmp -type f -atime +10)
        echo -e "\nArchivos en la papelera a eliminar:"
        find ~/.local/share/Trash/ -type f | while IFS= read -r file; do echo -e "\e[1;31m$file\e[0m"; done
        ;;
    *)
        echo "Opción no válida. Operación cancelada."
        exit 1
        ;;
esac

echo -e "\nResumen de acciones a realizar:\n$resumen"
echo -n "¿Deseas continuar con estas acciones y eliminar los archivos listados? (y/n): "
read -r confirmacion
if [[ "$confirmacion" != "y" && "$confirmacion" != "Y" ]]; then
    echo "Operación cancelada por el usuario."
    exit 0
fi

# Calcula el espacio libre antes de la limpieza
disk_before=$(df --output=avail / | tail -1)

# Función para limpieza con APT
clean_apt() {
    if [[ "$nivel" -ge 1 ]]; then
        echo "Limpiando archivos temporales de paquetes..."
        sudo apt clean
        sudo apt autoclean
    fi
    if [[ "$nivel" -ge 2 ]]; then
        echo "Eliminando paquetes innecesarios..."
        sudo apt autoremove --purge -y
        echo "Eliminando archivos de logs antiguos (no críticos)..."
        sudo find /var/log -name "*.log" -mtime +30 -exec rm -f {} \;
    fi
    if [[ "$nivel" -ge 3 ]]; then
        echo "Eliminando archivos temporales..."
        deleted_tmp=$(sudo find /tmp -type f -atime +10 -print -delete | wc -l)
        echo -e "\e[1;34mArchivos eliminados de /tmp: $deleted_tmp\e[0m"
        echo "Vaciando la papelera..."
        trash_dir="$HOME/.local/share/Trash/files"
        if [ -d "$trash_dir" ]; then
            # Método mejorado: maneja espacios en nombres y evita sudo
            find "$trash_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
                if ! rm -f "$file" 2>/dev/null; then
                    # Intenta ajustar permisos solo si es necesario
                    chmod u+rw "$file" 2>/dev/null
                    rm -f "$file" 2>/dev/null
                fi
            done
            deleted_trash=$(find "$trash_dir" -type f | wc -l)
            echo -e "\e[1;34mArchivos eliminados de la papelera: $deleted_trash\e[0m"
        else
            echo -e "\e[1;34mNo se encontró la papelera de archivos.\e[0m"
        fi
    fi
}

# Función para limpieza con DNF
clean_dnf() {
    if [[ "$nivel" -ge 1 ]]; then
        echo "Limpiando archivos temporales de paquetes..."
        sudo dnf clean all
        # Limpieza forzada de la caché de DNF
        echo "Forzando eliminación total de la caché de DNF..."
        sudo rm -rf /var/cache/dnf/*
    fi
    if [[ "$nivel" -ge 2 ]]; then
        echo "Eliminando paquetes innecesarios..."
        sudo dnf autoremove -y
        echo "Eliminando archivos de logs antiguos (no críticos)..."
        sudo find /var/log -name "*.log" -mtime +30 -exec rm -f {} \;
    fi
    if [[ "$nivel" -ge 3 ]]; then
        echo "Eliminando archivos temporales..."
        deleted_tmp=$(sudo find /tmp -type f -atime +10 -print -delete | wc -l)
        echo -e "\e[1;34mArchivos eliminados de /tmp: $deleted_tmp\e[0m"
        echo "Vaciando la papelera..."
        trash_dir="$HOME/.local/share/Trash/files"
        if [ -d "$trash_dir" ]; then
            find "$trash_dir" -type f -print0 | while IFS= read -r -d $'\0' file; do
                if ! rm -f "$file" 2>/dev/null; then
                    chmod u+rw "$file" 2>/dev/null
                    rm -f "$file" 2>/dev/null
                fi
            done
            deleted_trash=$(find "$trash_dir" -type f | wc -l)
            echo -e "\e[1;34mArchivos eliminados de la papelera: $deleted_trash\e[0m"
        else
            echo -e "\e[1;34mNo se encontró la papelera de archivos.\e[0m"
        fi
    fi
}

# Identificar el gestor de paquetes
disk_after=""
if command -v apt &> /dev/null; then
    clean_apt
    disk_after=$(df --output=avail / | tail -1)
elif command -v dnf &> /dev/null; then
    clean_dnf
    disk_after=$(df --output=avail / | tail -1)
else
    echo "No se pudo identificar un gestor de paquetes compatible (APT o DNF)."
    exit 1
fi

# Calcular y mostrar espacio liberado
if [[ -n "$disk_before" && -n "$disk_after" ]]; then
    space_freed=$(( (disk_after - disk_before) * 1024 ))
    if [[ $space_freed -gt 0 ]]; then
        human_freed=$(numfmt --to=iec --suffix=B $space_freed)
        echo -e "\e[1;34mEspacio liberado: $human_freed\e[0m"
    fi
fi

echo -e "\e[1;34mLimpieza completada.\e[0m"
