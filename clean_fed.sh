#!/bin/bash

echo "Iniciando limpieza del sistema..."

# 1. Ejecutar autoremove
echo "Eliminando paquetes innecesarios..."
sudo dnf autoremove -y

# 2. Ejecutar clean
echo "Limpiando archivos temporales de paquetes..."
sudo dnf clean all

# 3. Eliminar kernels antiguos
echo "Eliminando kernels antiguos..."
sudo dnf remove $(dnf repoquery --installonly --latest-limit=-2 -q)

# 4. Limpiar la caché de dnf
echo "Eliminando archivos de caché de dnf..."
sudo rm -rf /var/cache/dnf

# 5. Limpiar archivos temporales
echo "Eliminando archivos temporales..."
sudo rm -rf /tmp/*

# 6. Limpiar registros de logs antiguos
echo "Eliminando archivos de logs antiguos..."
sudo rm -rf /var/log/*.log

# 7. Vaciar la papelera
echo "Vaciando la papelera..."
rm -rf ~/.local/share/Trash/*

echo "Limpieza completada."
