# MIT License
#
# Copyright (c) 2018 - 2024 Matías Muñoz Espinoza
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

extends RPGNode

class_name RPGDialog

@export_node_path("RichTextLabel")
var text : NodePath

# Posición del avatar
enum AvatarPos {LEFT, RIGHT}
var avatar_pos = AvatarPos.LEFT

var dialogue := []

var timer

# Se cambia el trasmitter_name
signal transmitter_name_changed
# Se cambia el avatar
signal avatar_changed
# Pasa al siguiente texto
signal text_changed
# Comienza el dialogo
signal dialog_started
signal section_ended
# Termina el dialogo
signal dialog_ended

var next_pressed := false

var section_idx := 0


func add_section(character_name : String, message : String, avatar_image : TextureRect = null, avatar_position : AvatarPos = AvatarPos.LEFT):
	dialogue.append({
		"CHARACTER_NAME" : character_name,
		"MESSAGE" : message,
		"AVATAR_IMAGE" : avatar_image,
		"AVATAR_POSITION" : avatar_pos
	})


func next_dialog():
	if not dialogue and text:
		return
	
	if section_idx == dialogue.size():
		dialog_ended.emit()
		return
	
	var dialog_text = get_node(text) as RichTextLabel
	
	dialog_text.visible_ratio = 0.0
	
	var tween = create_tween()
	tween.tween_property(
		dialog_text,
		"visible_ratio",
		1.0,
		0.8
	)
	
	dialog_text.text = dialogue[section_idx]["MESSAGE"]
	
	section_idx += 1
	
