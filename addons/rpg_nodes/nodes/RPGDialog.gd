# MIT License
#
# Copyright (c) 2018 - 2025 Matías Muñoz Espinoza
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

## Remember set that variable to use the dialogs
@export_node_path("RichTextLabel")
var text : NodePath

## Remember set that variable to use the dialogs
@export_node_path("RichTextLabel")
var title_name : NodePath

## Remember set that variable to use the dialogs
@export_node_path("TextureRect")
var avatar : NodePath

var dialogue := []

var timer

## When the character name is changed
signal character_name_changed(old_name, new_name)
## Avatar changed
signal avatar_changed(old_image, new_image)
## Dialog started
signal dialog_started()
## Section ended, send the index of section
signal section_ended(idx : int)
## Dialog ended
signal dialog_ended()
## Clear dialog
signal dialog_cleaned

var next_pressed := false

var _section_idx := 0
var _prev_character_name := ""
var _prev_avatar_texture := ""

## add_section is used to add new dialog with name, message and optional avatar
func add_section(character_name : String, message : String, avatar_image := ""):
	dialogue.append({
		"CHARACTER_NAME" : character_name,
		"MESSAGE" : message,
		"AVATAR_TEXTURE" : avatar_image
	})

## next_dialog is used for start dialog or get_next dialog
func next_dialog():
	# If dialogue not exist or title_name is empty or text is empty send a message if debug is
	# active
	if not dialogue or title_name.is_empty() or text.is_empty():
		self.message.emit("Some of the properties are not assigned or no dialogue exists.")
		return
	
	if _section_idx == 0:
		dialog_started.emit()
	
	# If dialog ended emit the signal dialog_ended
	if _section_idx == dialogue.size():
		dialog_ended.emit()
		return
	
	# Set dialog_text and title_tex as nodes (RichTextLabel)
	var dialog_text = get_node(text) as RichTextLabel
	var title_text = get_node(title_name) as RichTextLabel
	
	# Visible ratio of dialog text, reset for each iteration
	dialog_text.visible_ratio = 0.0
	
	# Animation effect to dialog
	var tween = create_tween()
	tween.tween_property(
		dialog_text,
		"visible_ratio",
		1.0,
		0.8
	)
	
	# Asign the current message and character title to the RichTextLabels
	dialog_text.text = dialogue[_section_idx]["MESSAGE"]
	title_text.text = dialogue[_section_idx]["CHARACTER_NAME"]
	
	# Detect if character name is changed and emit a signal if is changed
	if _prev_character_name != dialogue[_section_idx]["MESSAGE"]:
		character_name_changed.emit(_prev_character_name, dialogue[_section_idx]["MESSAGE"])
		_prev_character_name = dialogue[_section_idx]["MESSAGE"]
	
	if dialogue[_section_idx]["AVATAR_TEXTURE"]:
		var avatar_image = get_node(avatar) as TextureRect
		avatar_image.texture = load(dialogue[_section_idx]["AVATAR_TEXTURE"])
	
	# Detect if avatar texture is changed and emit a signal if is changed
	if _prev_avatar_texture != dialogue[_section_idx]["AVATAR_TEXTURE"]:
		avatar_changed.emit(_prev_avatar_texture, dialogue[_section_idx]["AVATAR_TEXTURE"])
		_prev_avatar_texture = dialogue[_section_idx]["AVATAR_TEXTURE"]
	
	# Increase the index, for next section of dialog
	_section_idx += 1
	
	section_ended.emit(_section_idx)


## Reset index to start again the dialog section
func reset_index():
	_section_idx = 0


func clear_dialog():
	dialogue.clear()
