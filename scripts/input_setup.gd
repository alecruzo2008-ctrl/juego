extends Node

const ACCIONES := {
	"izquierda": [KEY_LEFT, KEY_A],
	"derecha": [KEY_RIGHT, KEY_D],
	"arriba": [KEY_UP, KEY_W],
	"abajo": [KEY_DOWN, KEY_S],
	"interactuar": [KEY_E, KEY_SPACE],
	"enciclopedia": [KEY_TAB],
	"pausa": [KEY_ESCAPE],
}

func _ready() -> void:
	for accion in ACCIONES:
		if not InputMap.has_action(accion):
			InputMap.add_action(accion)
		for tecla in ACCIONES[accion]:
			var evento := InputEventKey.new()
			evento.physical_keycode = tecla
			InputMap.action_add_event(accion, evento)

