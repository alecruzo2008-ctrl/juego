extends Control

func _ready() -> void:
	var titulo := Label.new()
	titulo.text = "Huella Extinta"
	titulo.position = Vector2(430, 250)
	titulo.add_theme_font_size_override("font_size", 40)
	add_child(titulo)
	var aviso := Label.new()
	aviso.text = "Prototipo educativo en desarrollo"
	aviso.position = Vector2(430, 310)
	add_child(aviso)

