# Clean-UX
ShellScripts for cleaning linux in APT and DNF, emptying the disk of obsolete files.

Just download the `clean_ux.sh` file and execute it from the shell with `./clean_ux.sh`

## Actions
1. **Eliminar paquetes innecesarios**: Quita automáticamente los paquetes que fueron instalados como dependencias y que ya no se requieren.

2. **Limpiar la caché de DNF**: Elimina todos los archivos y metadatos almacenados en la caché del gestor de paquetes DNF.

3. **Eliminar versiones antiguas de paquetes**: Quita las versiones de paquetes instalados que no son las más recientes, conservando solo las dos últimas.

4. **Eliminar la caché de DNF**: Borra todo el contenido de la carpeta de caché específica de DNF.

5. **Eliminar archivos temporales**: Limpia el directorio temporal del sistema, eliminando archivos que no son necesarios.

6. **Eliminar archivos de log**: Borra todos los registros de log del sistema, liberando espacio en disco.

7. **Vaciar la papelera de reciclaje**: Elimina todos los archivos almacenados en la papelera de reciclaje del usuario actual.
