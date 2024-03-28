extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$RPGDialog.add_section(
		"Juanito",
		"¿Hola soy GameDev y tu que clase de animal eres?"
	)
	$RPGDialog.add_section(
		"Pepito",
		"¿Cómo que animal? que creido eres!!"
	)
	$RPGDialog.add_section(
		"Juanito",
		"Sí eres un animal!! por que no eres GameDev!!"
	)


func _on_next_pressed():
	$RPGDialog.next_dialog()
