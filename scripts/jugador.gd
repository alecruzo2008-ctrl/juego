extends CharacterBody2D

@export var velocidad := 150.0

func _physics_process(_delta: float) -> void:
	var direccion := Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	velocity = direccion * velocidad
	move_and_slide()
	get_node("/root/EstadoJuego").posicion = global_position

