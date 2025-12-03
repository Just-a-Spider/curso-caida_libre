# Simulador de Caída Libre

Esta aplicación es una herramienta interactiva diseñada para simular el fenómeno físico de la caída libre. Permite a los estudiantes experimentar con variables como la gravedad, la altura y la resistencia del aire en un entorno visual y amigable.

Este proyecto fue desarrollado como parte del trabajo de clase para el curso de **Software Libre**.

## Características Principales

- **Simulación Física**: Cálculos en tiempo real de posición y velocidad.
- **Resistencia del Aire**: Opción para activar y ajustar el coeficiente de arrastre.
- **Zoom Dinámico**: La cámara se ajusta automáticamente para seguir objetos lanzados hacia arriba.
- **Multiplataforma**: Funciona en Windows, Linux y Android.

## Instrucciones de Replicación

Para ejecutar este proyecto en tu entorno local, sigue estos pasos sencillos:

1. **Prerrequisitos**: Asegúrate de tener instalado el [SDK de Flutter](https://flutter.dev/docs/get-started/install).
2. **Clonar**: Descarga el código fuente de este repositorio.
3. **Dependencias**: Abre una terminal en la carpeta del proyecto e instala las librerías necesarias:
   ```bash
   flutter pub get
   ```
4. El ejecutable estará en `build\windows\x64\runner\Release\caida_libre.exe`

## Integración Continua (CI/CD)

Este proyecto cuenta con un flujo de trabajo de GitHub Actions que genera automáticamente los ejecutables para Android, Linux y Windows.

Cada vez que se hace un **Push** o **Pull Request** a la rama `main`:

1. Se compila el proyecto en los tres sistemas operativos.
2. Se suben los artefactos generados (APK y Zips) a la pestaña **Actions** de GitHub.

Para descargar la última versión:

1. Ve a la pestaña **Actions** en el repositorio de GitHub.
2. Haz clic en la última ejecución del flujo "Build and Release".
3. Baja a la sección "Artifacts" y descarga el archivo que necesites.

### Crear una Release

Para generar una versión oficial (Release) en GitHub con archivos descargables:

1. Crea un tag con la versión (ej. `v1.0`):
   ```bash
   git tag v1.0
   git push origin v1.0
   ```
2. GitHub Actions detectará el tag, compilará la app y creará automáticamente la **Release** con los archivos adjuntos.
3. **Ejecutar**: Lanza la aplicación en tu dispositivo o emulador preferido:
   ```bash
   flutter run
   ```
   _(Para Linux/Windows, usa `flutter run -d linux` o `flutter run -d windows`)_

## Colaboración

¡Las contribuciones son bienvenidas! Si deseas mejorar este simulador:

1. Haz un **Fork** de este repositorio.
2. Crea una rama para tu mejora (`git checkout -b feature/mi-mejora`).
3. Realiza tus cambios y haz **Commit**.
4. Envía un **Pull Request** explicando qué has añadido o arreglado.

---

_Proyecto académico - Curso de Software Libre_
