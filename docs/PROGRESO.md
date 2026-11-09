# Progreso de desarrollo

## Decisiones del equipo

- Juego: Huella Extinta.
- Ecosistema inicial: bosque andino de niebla.
- Animal jugable: oso de anteojos (*Tremarctos ornatus*).
- Motor: Godot 4.7.2 estable, versión estándar.

## Bitácora

| Fase | Estado | Evidencia |
|---|---|---|
| 0. Entorno y repositorio | Completa | Godot 4.7.2; proyecto abre en modo headless. Commit inicial. |
| 1. Autoloads y entradas | Completa | `InputSetup` registra controles; `EstadoJuego` centraliza estado y señales. |
| 2. Jugador, movimiento y cámara | Completa | Personaje provisional y cámara incluidos; controles de ocho direcciones. |
| 3. Mapa del ecosistema | Completa | Mapa 40x30, TileSet con obstáculos sólidos y zonas transitables. |
| 4. Interacción | Completa | Frutos, guardabosques y cartel con diálogo contextual. |
| 5. Vida, energía y HUD | Completa | Energía gradual, daño, alimento, HUD y pantalla de fin. |
| 6. Misión | Completa | Recoger tres frutos y hablar con el guardabosques. |
| 7. Enciclopedia | Completa | Ficha del oso andino con fuentes del Instituto Humboldt. |
| 8. Menú, guardado y opciones | Completa | Nueva partida, continuar, volumen, pausa y guardado JSON. |
| 9. Pruebas | Completa | CP01–CP06 pasan en `tests/test_cp01_cp06.gd`; detalles en `docs/PRUEBAS.md`. |
| 10. Exportación y entrega | Parcial | Manual, créditos y proyecto listos. Falta instalar plantillas de exportación desde el editor y probar el ejecutable Windows. |

