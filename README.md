# Huella Extinta

Prototipo educativo 2D de exploración sobre el oso de anteojos en un bosque andino de niebla. Se desarrolló con Godot 4.7.2 estándar y GDScript para PC.

## Abrir el juego

1. Descarga Godot 4.3 o superior desde [godotengine.org/download](https://godotengine.org/download/).
2. Abre Godot, importa esta carpeta y pulsa Ejecutar proyecto.

## Controles y objetivo

- **WASD o flechas:** moverse en ocho direcciones.
- **E o espacio:** interactuar con frutos, guardabosques y cartel cuando aparezca el aviso.
- **Tab:** abrir o cerrar la enciclopedia.
- **Esc:** pausar o reanudar.

Recoge tres frutos para recuperar energía y habla con el guardabosques para completar la misión. Evita la zona de riesgo. El oso pierde energía con el tiempo; cuando llega a cero, pierde vida. La pausa permite guardar y volver al menú. La partida continúa desde la posición, vida, energía y misión guardadas.

Los gráficos son placeholders de color generados por `tools/generar_placeholders.gd`. El renderizador es Compatibility. Para abrir desde terminal usa `godot --path .`; para validar el proyecto usa `godot --headless --path . --quit`.

## Estado

El MVP está implementado y los casos automatizados CP01 a CP06 pasan. La exportación de Windows queda pendiente de instalar las plantillas de exportación desde el editor Godot; ver `docs/PROGRESO.md`.

