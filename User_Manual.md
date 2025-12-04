# Manual de Usuario - GraviLab

Bienvenido a **GraviLab**. Esta aplicación educativa está diseñada para ayudar a estudiantes y profesores a visualizar y comprender los conceptos físicos del movimiento en caída libre, con y sin resistencia del aire.

## Tabla de Contenidos

1. [Navegación](#navegación)
2. [Modo Simulador](#modo-simulador)
   - [Configuración de Parámetros](#configuración-de-parámetros)
   - [Resistencia del Aire](#resistencia-del-aire)
   - [Controles de Reproducción](#controles-de-reproducción)
   - [Visualización](#visualización)
3. [Modo Desafío](#modo-desafío)
   - [Resolviendo Problemas](#resolviendo-problemas)
   - [Verificación](#verificación)

---

## Navegación

La aplicación cuenta con dos modos principales, accesibles desde la barra de navegación en la parte inferior de la pantalla:

- **Simulador**: El laboratorio virtual donde puedes experimentar libremente.
- **Desafíos**: Un modo de práctica con problemas generados aleatoriamente para poner a prueba tus conocimientos.

---

## Modo Simulador

Este es el modo principal de la aplicación. Aquí puedes configurar un escenario físico y ver cómo evoluciona en tiempo real.

### Configuración de Parámetros

En el panel de configuración (a la izquierda o abajo, dependiendo de tu dispositivo), puedes ajustar:

- **Altura Inicial (m)**: Desde qué altura cae el objeto.
- **Gravedad (m/s²)**: La fuerza de atracción.
  - _9.81_ es la gravedad estándar de la Tierra.
  - Prueba _1.62_ para la Luna o _3.72_ para Marte.
- **Velocidad Inicial (m/s)**:
  - **0**: El objeto se deja caer (caída libre pura).
  - **Positivo (ej. 10)**: El objeto es lanzado hacia arriba.
  - **Negativo (ej. -10)**: El objeto es lanzado hacia abajo.

### Resistencia del Aire

Puedes activar el interruptor **"Resistencia del Aire"** para simular una atmósfera.

- **Coeficiente de Arrastre**: Usa el deslizador para ajustar qué tanto "frena" el aire al objeto.
  - Valores bajos (0.1) simulan objetos aerodinámicos (como una bola de boliche).
  - Valores altos (0.8 - 1.0) simulan objetos con mucha resistencia (como una pluma o un paracaídas).

### Controles de Reproducción

- **Aplicar**: Guarda los cambios realizados en los parámetros. **Debes pulsar esto antes de iniciar si cambiaste algún número.**
- **Iniciar / Pausar**: Comienza o detiene la simulación.
- **Reiniciar (Botón Rojo)**: Devuelve el objeto a la posición inicial y restablece el tiempo a cero.

### Visualización

- **Objeto**: Una esfera roja representa el cuerpo en caída.
- **Regla**: Una guía visual a la izquierda muestra la altura en metros.
- **Zoom Dinámico**: Si lanzas el objeto muy alto, la cámara se alejará automáticamente para mantenerlo en pantalla.
- **Datos en Tiempo Real**: En la esquina superior verás:
  - Tiempo transcurrido ($t$)
  - Altura actual ($h$)
  - Velocidad actual ($v$)

---

## Modo Desafío

Pon a prueba lo que has aprendido resolviendo problemas de física generados por la computadora.

### Resolviendo Problemas

1.  Al entrar, verás un **enunciado** (por ejemplo: _"Calcula el tiempo que tarda en caer..."_).
2.  Identifica los datos proporcionados (Altura, Gravedad, etc.).
3.  Usa tu calculadora y las fórmulas de caída libre para hallar la respuesta.
4.  Escribe tu resultado en el campo **"Tu Respuesta"**.
5.  Pulsa **"Verificar Respuesta"**.

> **Nota**: El sistema acepta un margen de error del 5%, así que no te preocupes por pequeños errores de redondeo.

### Verificación

Si tu respuesta es correcta (¡o incorrecta!), aparecerá una explicación detallada.

- Pulsa el botón **"Ver en Simulador"** para cargar automáticamente los datos de ese problema en el Modo Simulador.
- Esto te llevará de vuelta a la pantalla principal con la altura y gravedad del problema ya configuradas, para que puedas ver visualmente si tu cálculo coincide con la realidad.

---

## Consejos Rápidos

- Si la simulación va muy rápido, intenta pausarla para ver los valores en un momento específico.
- ¡Experimenta! ¿Qué pasa si lanzas un objeto hacia arriba con mucha resistencia del aire? ¿Cae más lento de lo que subió?
