extends Control

var continuar: Button

func _ready() -> void:
	var caja := VBoxContainer.new()
	caja.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	caja.position = Vector2(-170, -160)
	caja.custom_minimum_size = Vector2(340, 320)
	caja.add_theme_constant_override("separation", 14)
	add_child(caja)
	var titulo := Label.new()
	titulo.text = "Huella Extinta"
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_font_size_override("font_size", 40)
	caja.add_child(titulo)
	var subtitulo := Label.new()
	subtitulo.text = "Explora el bosque andino con el oso de anteojos"
	subtitulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caja.add_child(subtitulo)
	var nueva := Button.new()
	nueva.text = "Nueva partida"
	nueva.pressed.connect(_nueva_partida)
	caja.add_child(nueva)
	continuar = Button.new()
	continuar.text = "Continuar"
	continuar.disabled = not FileAccess.file_exists("user://partida.json")
	continuar.pressed.connect(_continuar)
	caja.add_child(continuar)
	var opciones := HSlider.new()
	opciones.min_value = 0
	opciones.max_value = 1
	opciones.step = 0.05
	opciones.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	opciones.value_changed.connect(func(valor: float) -> void:
		AudioServer.set_bus_volume_db(0, linear_to_db(maxf(valor, 0.001))))
	caja.add_child(opciones)
	var salida := Button.new()
	salida.text = "Salir"
	salida.pressed.connect(func() -> void: get_tree().quit())
	caja.add_child(salida)

func _nueva_partida() -> void:
	get_node("/root/EstadoJuego").reiniciar()
	var misiones: Node = get_node("/root/MisionManager")
	misiones.frutos = 0
	misiones.hablo_guardabosques = false
	misiones.completada = false
	get_tree().change_scene_to_file("res://scenes/mundo.tscn")

func _continuar() -> void:
	var datos = JSON.parse_string(FileAccess.get_file_as_string("user://partida.json"))
	if not datos is Dictionary:
		return
	var estado: Node = get_node("/root/EstadoJuego")
	estado.zona = str(datos.get("zona", "bosque_andino"))
	var posicion: Array = datos.get("posicion", [160, 160])
	estado.posicion = Vector2(float(posicion[0]), float(posicion[1]))
	estado.vida = float(datos.get("vida", 100))
	estado.energia = float(datos.get("energia", 100))
	get_node("/root/MisionManager").cargar_estado(datos.get("misiones", {}))
	get_tree().change_scene_to_file("res://scenes/mundo.tscn")

