extends Node

signal vida_cambiada(valor: float)
signal energia_cambiada(valor: float)
signal mision_actualizada(texto: String)

var vida_maxima := 100.0
var energia_maxima := 100.0
var vida := 100.0
var energia := 100.0
var mision_activa := "Encontrar alimento"
var zona := "bosque_andino"
var posicion := Vector2(160, 160)

func cambiar_vida(cantidad: float) -> void:
	vida = clampf(vida + cantidad, 0.0, vida_maxima)
	vida_cambiada.emit(vida)

func cambiar_energia(cantidad: float) -> void:
	energia = clampf(energia + cantidad, 0.0, energia_maxima)
	energia_cambiada.emit(energia)

