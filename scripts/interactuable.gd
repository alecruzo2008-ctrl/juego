extends Area2D
class_name Interactuable

signal interactuado(id: String)

@export var id := ""
@export_multiline var texto := ""
@export var tipo := "info"
var disponible := true
var cerca := false

func _ready() -> void:
	add_to_group("interactuables")
	body_entered.connect(_al_entrar)
	body_exited.connect(_al_salir)

func _al_entrar(cuerpo: Node2D) -> void:
	if cuerpo is CharacterBody2D:
		cerca = true

func _al_salir(cuerpo: Node2D) -> void:
	if cuerpo is CharacterBody2D:
		cerca = false

func interactuar() -> void:
	if cerca and disponible:
		interactuado.emit(id)
		if tipo == "fruto":
			disponible = false
			queue_free()

