#!/bin/bash

echo "Iniciando limpieza del sistema..."

# Función para limpieza con APT
clean_apt() {
    echo "Eliminando paquetes innecesarios..."
    sudo apt autoremove -y

    echo "Limpiando archivos temporales de paquetes..."
    sudo apt clean

    echo "Eliminando paquetes obsoletos..."
    sudo apt autoclean

    echo "Eliminando kernels antiguos..."
    sudo apt autoremove --purge -y

    echo "Eliminando archivos de caché de apt..."
    sudo rm -rf /var/cache/apt/archives/*

    echo "Eliminando archivos temporales..."
    sudo rm -rf /tmp/*

    echo "Eliminando archivos de logs antiguos..."
    sudo rm -rf /var/log/*.log

    echo "Vaciando la papelera..."
    rm -rf ~/.local/share/Trash/*
}

# Función para limpieza con DNF
clean_dnf() {
    echo "Eliminando paquetes innecesarios..."
    sudo dnf autoremove -y

    echo "Limpiando archivos temporales de paquetes..."
    sudo dnf clean all

    echo "Eliminando kernels antiguos..."
    sudo dnf remove $(dnf repoquery --installonly --latest-limit=-2 -q)

    echo "Eliminando archivos de caché de dnf..."
    sudo rm -rf /var/cache/dnf

    echo "Eliminando archivos temporales..."
    sudo rm -rf /tmp/*

    echo "Eliminando archivos de logs antiguos..."
    sudo rm -rf /var/log/*.log

    echo "Vaciando la papelera..."
    rm -rf ~/.local/share/Trash/*
}

# Identificar el gestor de paquetes
if command -v apt &> /dev/null; then
    clean_apt
elif command -v dnf &> /dev/null; then
    clean_dnf
else
    echo "No se pudo identificar un gestor de paquetes compatible (APT o DNF)."
    exit 1
fi

echo "Limpieza completada."
