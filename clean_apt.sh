#!/bin/bash

echo "Iniciando limpieza del sistema..."

# 1. Ejecutar autoremove
echo "Eliminando paquetes innecesarios..."
sudo apt autoremove -y

# 2. Ejecutar clean
echo "Limpiando archivos temporales de paquetes..."
sudo apt clean

# 3. Ejecutar autoclean
echo "Eliminando paquetes obsoletos..."
sudo apt autoclean

# 4. Eliminar kernels antiguos
echo "Eliminando kernels antiguos..."
sudo apt autoremove --purge -y

# 5. Limpiar la caché de apt
echo "Eliminando archivos de caché de apt..."
sudo rm -rf /var/cache/apt/archives/*

# 6. Limpiar archivos temporales
echo "Eliminando archivos temporales..."
sudo rm -rf /tmp/*

# 7. Limpiar registros de logs antiguos
echo "Eliminando archivos de logs antiguos..."
sudo rm -rf /var/log/*.log

# 8. Vaciar la papelera
echo "Vaciando la papelera..."
rm -rf ~/.local/share/Trash/*

echo "Limpieza completada."
