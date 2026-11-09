extends Node2D

var actual: Interactuable
var capa_ui: CanvasLayer
var etiqueta_dialogo: Label
var barra_vida: ProgressBar
var barra_energia: ProgressBar
var etiqueta_mision: Label
var panel_enciclopedia: PanelContainer
var panel_pausa: PanelContainer
var panel_fin: PanelContainer
var tiempo_peligro := 0.0
var estado: Node
var misiones: Node

func _ready() -> void:
	estado = get_node("/root/EstadoJuego")
	misiones = get_node("/root/MisionManager")
	var jugador := get_node_or_null("Jugador")
	if jugador:
		jugador.position = estado.posicion
	construir_elementos()
	crear_interfaz()
	estado.vida_cambiada.connect(_actualizar_vida)
	estado.energia_cambiada.connect(_actualizar_energia)
	misiones.mision_actualizada.connect(_actualizar_mision)
	_actualizar_vida(estado.vida)
	_actualizar_energia(estado.energia)
	_actualizar_mision(misiones.texto_mision())

func construir_elementos() -> void:
	crear_interactuable("fruto1", "Recogiste un fruto y recuperaste energía.", "fruto", Vector2(260, 190), Color("#e7b84b"))
	crear_interactuable("fruto2", "Recogiste un fruto y recuperaste energía.", "fruto", Vector2(470, 160), Color("#e7b84b"))
	crear_interactuable("fruto3", "Recogiste un fruto y recuperaste energía.", "fruto", Vector2(650, 390), Color("#e7b84b"))
	crear_interactuable("guardabosques", "Guardabosques: reúne tres frutos para conocer una acción de cuidado del bosque.", "npc", Vector2(540, 330), Color("#8b6544"))
	crear_interactuable("cartel", "Oso de anteojos: consulta la enciclopedia para conocer su hábitat y amenazas.", "info", Vector2(760, 210), Color("#d5c18a"))
	var peligro := Area2D.new()
	peligro.name = "ZonaPeligro"
	var forma := CollisionShape2D.new()
	var circulo := CircleShape2D.new()
	circulo.radius = 28
	forma.shape = circulo
	peligro.add_child(forma)
	peligro.position = Vector2(900, 470)
	add_child(peligro)
	peligro.body_entered.connect(_zona_peligro)

func _zona_peligro(cuerpo: Node2D) -> void:
	if cuerpo is CharacterBody2D:
		estado.cambiar_vida(-5)

func crear_interactuable(nombre: String, mensaje: String, categoria: String, lugar: Vector2, color: Color) -> void:
	var objeto := Area2D.new()
	objeto.name = nombre
	objeto.set_script(load("res://scripts/interactuable.gd"))
	objeto.id = nombre
	objeto.texto = mensaje
	objeto.tipo = categoria
	objeto.position = lugar
	var forma := CollisionShape2D.new()
	var circulo := CircleShape2D.new()
	circulo.radius = 25
	forma.shape = circulo
	objeto.add_child(forma)
	var figura := Polygon2D.new()
	figura.polygon = PackedVector2Array([Vector2(-10,-10), Vector2(10,-10), Vector2(10,10), Vector2(-10,10)])
	figura.color = color
	objeto.add_child(figura)
	add_child(objeto)
	objeto.interactuado.connect(_al_interactuar.bind(objeto))

func _unhandled_input(evento: InputEvent) -> void:
	if evento.is_action_pressed("interactuar") and actual:
		actual.interactuar()
	if evento.is_action_pressed("enciclopedia"):
		panel_enciclopedia.visible = not panel_enciclopedia.visible
	if evento.is_action_pressed("pausa"):
		panel_pausa.visible = not panel_pausa.visible
		get_tree().paused = panel_pausa.visible

func _process(delta: float) -> void:
	estado.avanzar_supervivencia(delta)
	var cerca: Interactuable
	for nodo in get_tree().get_nodes_in_group("interactuables"):
		if nodo is Interactuable and nodo.cerca and nodo.disponible:
			cerca = nodo
	actual = cerca
	if cerca:
		etiqueta_dialogo.text = "E: interactuar con " + cerca.name
	elif tiempo_peligro > 0:
		etiqueta_dialogo.text = "Zona de riesgo: aléjate"
	else:
		etiqueta_dialogo.text = "WASD/flechas: mover · E: interactuar · Tab: enciclopedia · Esc: pausa"
	if estado.vida <= 0:
		panel_fin.visible = true
		get_tree().paused = true

func _al_interactuar(id: String, objeto: Interactuable) -> void:
	etiqueta_dialogo.text = objeto.texto
	misiones.registrar_interaccion(id)
	if id.begins_with("fruto"):
		estado.cambiar_energia(20)
	if id == "cartel":
		panel_enciclopedia.visible = true

func _actualizar_vida(valor: float) -> void:
	barra_vida.value = valor

func _actualizar_energia(valor: float) -> void:
	barra_energia.value = valor

func _actualizar_mision(texto: String) -> void:
	etiqueta_mision.text = texto

func crear_interfaz() -> void:
	capa_ui = CanvasLayer.new()
	add_child(capa_ui)
	var panel := PanelContainer.new()
	panel.position = Vector2(12, 12)
	panel.custom_minimum_size = Vector2(440, 122)
	capa_ui.add_child(panel)
	var caja := VBoxContainer.new()
	panel.add_child(caja)
	barra_vida = ProgressBar.new()
	barra_vida.max_value = 100
	barra_vida.show_percentage = false
	caja.add_child(_fila_barra(caja, "Vida", barra_vida))
	barra_energia = ProgressBar.new()
	barra_energia.max_value = 100
	barra_energia.show_percentage = false
	caja.add_child(_fila_barra(caja, "Energía", barra_energia))
	etiqueta_mision = Label.new()
	etiqueta_mision.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caja.add_child(etiqueta_mision)
	etiqueta_dialogo = Label.new()
	etiqueta_dialogo.position = Vector2(18, 590)
	etiqueta_dialogo.add_theme_color_override("font_color", Color.WHITE)
	capa_ui.add_child(etiqueta_dialogo)
	panel_enciclopedia = _crear_enciclopedia()
	panel_enciclopedia.position = Vector2(500, 115)
	panel_enciclopedia.visible = false
	capa_ui.add_child(panel_enciclopedia)
	panel_pausa = _crear_panel_pausa()
	panel_pausa.position = Vector2(430, 210)
	panel_pausa.visible = false
	panel_pausa.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	capa_ui.add_child(panel_pausa)
	panel_fin = PanelContainer.new()
	panel_fin.position = Vector2(390, 220)
	panel_fin.visible = false
	panel_fin.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	var fin_caja := VBoxContainer.new()
	panel_fin.add_child(fin_caja)
	var fin_texto := Label.new()
	fin_texto.text = "La vida del oso se agotó."
	fin_caja.add_child(fin_texto)
	var reiniciar := Button.new()
	reiniciar.text = "Reiniciar partida"
	reiniciar.pressed.connect(_reiniciar)
	fin_caja.add_child(reiniciar)
	capa_ui.add_child(panel_fin)

func _fila_barra(caja: VBoxContainer, nombre: String, barra: ProgressBar) -> Control:
	var fila := HBoxContainer.new()
	var titulo := Label.new()
	titulo.text = nombre
	titulo.custom_minimum_size.x = 82
	fila.add_child(titulo)
	barra.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fila.add_child(barra)
	return fila

func _crear_enciclopedia() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(540, 390)
	var caja := VBoxContainer.new()
	panel.add_child(caja)
	var titulo := Label.new()
	titulo.text = "Oso de anteojos · Tremarctos ornatus"
	titulo.add_theme_font_size_override("font_size", 22)
	caja.add_child(titulo)
	var datos: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/especies.json"))["especies"][0]
	for campo in ["habitat", "dieta", "distribucion", "amenazas", "fuente"]:
		var etiqueta := Label.new()
		etiqueta.text = campo.capitalize() + ": " + str(datos[campo])
		etiqueta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		caja.add_child(etiqueta)
	return panel

func _crear_panel_pausa() -> PanelContainer:
	var panel := PanelContainer.new()
	var caja := VBoxContainer.new()
	panel.add_child(caja)
	for especificacion in [["Reanudar", _reanudar], ["Guardar", _guardar], ["Volver al menú", _menu]]:
		var boton := Button.new()
		boton.text = especificacion[0]
		boton.pressed.connect(especificacion[1])
		caja.add_child(boton)
	return panel

func _reanudar() -> void:
	panel_pausa.visible = false
	get_tree().paused = false

func _guardar() -> void:
	var archivo := FileAccess.open("user://partida.json", FileAccess.WRITE)
	archivo.store_string(JSON.stringify({"zona": estado.zona, "posicion": [estado.posicion.x, estado.posicion.y], "vida": estado.vida, "energia": estado.energia, "misiones": misiones.guardar_estado()}))
	etiqueta_dialogo.text = "Partida guardada."

func _menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")

func _reiniciar() -> void:
	get_tree().paused = false
	estado.reiniciar()
	misiones.frutos = 0
	misiones.hablo_guardabosques = false
	misiones.completada = false
	get_tree().reload_current_scene()

