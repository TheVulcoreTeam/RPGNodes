extends Control


func _ready():
	$RPGDialog.add_section(
		"GameDev",
		"Hello I am a GameDev and you what kind of animal you are?",
		"res://tests/dialog/RPGDialog/gamedev.png"
	)
	$RPGDialog.add_section(
		"Animal",
		"What do you mean, animal? You're such a conceited animal!",
		"res://tests/dialog/RPGDialog/animal.png"
	)
	$RPGDialog.add_section(
		"GameDev",
		"Yes you are a animal, because you're not a GameDev!",
		"res://tests/dialog/RPGDialog/gamedev.png"
	)
	$RPGDialog.add_section(
		"Animal",
		"You're a braggart like all GameDevs!!",
		"res://tests/dialog/RPGDialog/animal.png"
	)

func _on_next_pressed():
	$RPGDialog.next_dialog()
