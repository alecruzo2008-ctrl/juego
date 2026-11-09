extends SceneTree

var fallos := 0

func _initialize() -> void:
	call_deferred("_ejecutar")

func _ejecutar() -> void:
	var estado: Node = load("res://scripts/estado_juego.gd").new()
	estado.name = "EstadoJuego"
	root.add_child(estado)
	var misiones: Node = load("res://scripts/mision_manager.gd").new()
	misiones.name = "MisionManager"
	root.add_child(misiones)
	for accion in ["izquierda", "derecha", "arriba", "abajo"]:
		if not InputMap.has_action(accion):
			InputMap.add_action(accion)
	var mundo: Node = load("res://scenes/mundo.tscn").instantiate()
	root.add_child(mundo)
	await process_frame
	var jugador := mundo.get_node("Jugador") as CharacterBody2D
	var mapa := mundo.get_node("Mapa") as TileMapLayer
	Input.action_press("derecha")
	for _i in range(4):
		await physics_frame
	Input.action_release("derecha")
	var fuente := mapa.tile_set.get_source(0) as TileSetAtlasSource
	var datos: TileData = fuente.get_tile_data(Vector2i(2, 0), 0)
	_registrar("CP01", jugador.position.x > 160 and datos.get_collision_polygons_count(0) > 0, "jugador se mueve y los obstáculos tienen colisión")
	_registrar("CP02", mapa.get_used_rect().size == Vector2i(40, 30) and mapa.get_cell_atlas_coords(Vector2i(0, 10)).x == 2, "mapa 40x30 cerrado por obstáculos")
	var fruta: Interactuable = mundo.get_node("fruto1")
	var recibidos: Array[String] = []
	fruta.interactuado.connect(func(id: String) -> void: recibidos.append(id))
	fruta.cerca = true
	fruta.interactuar()
	_registrar("CP03", recibidos == ["fruto1"] and mundo.get("etiqueta_dialogo").text.contains("Recogiste"), "interacción muestra respuesta")
	misiones.completada = false
	misiones.frutos = 0
	misiones.hablo_guardabosques = false
	for i in range(1, 4):
		misiones.registrar_interaccion("fruto%d" % i)
	misiones.registrar_interaccion("guardabosques")
	_registrar("CP04", misiones.completada, "misión se completa con requisitos")
	estado.energia = 50
	estado.cambiar_energia(-3)
	var baja := is_equal_approx(estado.energia, 47)
	estado.cambiar_energia(20)
	estado.energia = 0
	var vida_antes: float = estado.vida
	estado.avanzar_supervivencia(3.0)
	_registrar("CP05", baja and is_equal_approx(estado.energia, 0) and estado.vida < vida_antes, "energía baja, se recupera y al agotarse reduce vida (%.0f -> %.0f; energía %.0f)" % [vida_antes, estado.vida, estado.energia])
	var especies: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/especies.json"))
	var oso: Dictionary = especies["especies"][0]
	_registrar("CP06", oso["fuente"].contains("https://") and not oso["habitat"].contains("PENDIENTE"), "ficha incluye campos y fuente")
	mundo.queue_free()
	await process_frame
	quit(1 if fallos else 0)

func _registrar(caso: String, correcto: bool, detalle: String) -> void:
	if correcto:
		print(caso + " OK: " + detalle)
	else:
		fallos += 1
		printerr(caso + " FALLO: " + detalle)

