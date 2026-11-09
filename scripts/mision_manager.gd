extends Node

signal mision_actualizada(texto: String)

var frutos := 0
var hablo_guardabosques := false
var completada := false

func registrar_interaccion(id: String) -> void:
	if id.begins_with("fruto") and not completada:
		frutos += 1
	if id == "guardabosques":
		hablo_guardabosques = true
	if frutos >= 3 and hablo_guardabosques and not completada:
		completada = true
		EstadoJuego.mision_activa = "Misión completada: bosque protegido"
	mision_actualizada.emit(texto_mision())

func texto_mision() -> String:
	if completada:
		return "Misión completada: bosque protegido"
	return "Recoge 3 frutos (%d/3) y habla con el guardabosques" % frutos

func guardar_estado() -> Dictionary:
	return {"frutos": frutos, "hablo_guardabosques": hablo_guardabosques, "completada": completada}

func cargar_estado(datos: Dictionary) -> void:
	frutos = int(datos.get("frutos", 0))
	hablo_guardabosques = bool(datos.get("hablo_guardabosques", false))
	completada = bool(datos.get("completada", false))
	mision_actualizada.emit(texto_mision())

