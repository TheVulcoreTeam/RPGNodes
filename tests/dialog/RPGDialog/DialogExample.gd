extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$RPGDialog.add_section(
		"GameDev",
		"¿Hola soy GameDev y tu que clase de animal eres?",
		"res://tests/dialog/RPGDialog/gamedev.png"
	)
	$RPGDialog.add_section(
		"Animal",
		"¿Cómo que animal? que creido eres!!",
		"res://tests/dialog/RPGDialog/animal.png"
	)
	$RPGDialog.add_section(
		"GameDev",
		"Sí eres un animal!! por que no eres GameDev!!",
		"res://tests/dialog/RPGDialog/gamedev.png"
	)
	$RPGDialog.add_section(
		"Animal",
		"Eres un fanfarron como todos los GameDevs!!",
		"res://tests/dialog/RPGDialog/animal.png"
	)

func _on_next_pressed():
	$RPGDialog.next_dialog()
