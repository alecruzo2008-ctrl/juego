# Pruebas del prototipo

Fecha de ejecución: 9 de noviembre de 2026. Motor: Godot 4.7.2 estable estándar. Versión del código: `c1e2e82` (`feature/mvp-huella-extinta`).

Comando de pruebas: `godot --headless --path . --script res://tests/test_cp01_cp06.gd`.

| ID | Comprobación | Resultado |
|---|---|---|
| CP01 | El jugador se mueve y los obstáculos tienen polígonos de colisión. | OK |
| CP02 | El mapa tiene 40x30 celdas y borde bloqueante. | OK |
| CP03 | Interactuar muestra respuesta visible. | OK |
| CP04 | Tres frutos y hablar con el guardabosques completan la misión. | OK |
| CP05 | La energía baja, se recupera con alimento y al agotarse reduce vida. | OK |
| CP06 | La ficha contiene campos de especie y fuente verificable. | OK |

Validación general: `godot --headless --editor --path . --quit` y `godot --headless --path . --quit` terminan sin errores ni advertencias de scripts. La respuesta de control y la claridad de la interfaz requieren validación manual del equipo en el editor.
