# Clean-UX

**Clean-UX** es un script avanzado de limpieza de sistema para Linux, interactivo, fiable y compatible tanto con sistemas basados en APT (Debian, Ubuntu) como DNF (Fedora, RHEL, etc).

## Características principales

- **Banner visual**: Muestra un banner ASCII colorido al iniciar.
- **Menú interactivo**: Selección de nivel de limpieza (básica, intermedia, profunda, salir) con explicación de cada nivel.
- **Resumen y confirmación**: Antes de ejecutar, muestra un resumen de acciones y un listado de archivos a eliminar, con colores según el nivel:
  - Verde: limpieza básica
  - Amarillo: limpieza intermedia
  - Rojo: limpieza profunda
- **Limpieza efectiva**:
  - Para APT: ejecuta `apt clean`, `apt autoclean`, y `apt autoremove` según el nivel.
  - Para DNF: ejecuta `dnf clean all`, `dnf autoremove` y fuerza la eliminación total de la caché (`sudo rm -rf /var/cache/dnf/*`) para asegurar que no queden archivos residuales.
  - Elimina logs antiguos (>30 días), archivos temporales de `/tmp` (no accedidos en 10 días) y vacía la papelera de usuario.
- **Gestión de permisos**: Intenta ajustar permisos de archivos rebeldes para asegurar su eliminación.
- **Reporte final**: Muestra espacio liberado y número de archivos eliminados en azul.
- **Explicaciones**: Si quedan archivos sin borrar, explica posibles causas (permisos, archivos en uso, etc).

## Niveles de limpieza

1. **Básica**: Limpia caché de paquetes y archivos temporales de paquetes.
2. **Intermedia**: Todo lo anterior + elimina paquetes innecesarios y logs antiguos.
3. **Profunda**: Todo lo anterior + limpia `/tmp` y vacía la papelera.

## Uso

```bash
chmod +x clean_ux.sh
./clean_ux.sh
```

Sigue las instrucciones en pantalla para seleccionar el nivel de limpieza y confirmar las acciones.

## Requisitos
- Bash
- Permisos de sudo para limpiar cachés y logs del sistema
- Sistemas basados en APT o DNF

## Notas
- En sistemas DNF, la limpieza de caché es forzada para asegurar que no queden archivos residuales.
- En sistemas APT, la limpieza estándar es suficiente y segura.
- El script maneja espacios y permisos en nombres de archivos.

---

¡Disfruta de un sistema limpio y optimizado con Clean-UX!
