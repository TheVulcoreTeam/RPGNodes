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

# Estos son las propiedades que deben ser asignadas a la interfaz:
# transmitter_name : Es el nombre que emite el mensaje actual.
# avatar : texture de avatar, imagen actual. (Debe de ser un Sprite)
# text: texto actual. 
var transmitter_name
var avatar
var text

# Posición del avatar
enum AvatarPos {LEFT, RIGHT}
var avatar_pos = AvatarPos.LEFT

var dialogue = []

var timer

# Se cambia el trasmitter_name
signal changed_transmitter_name # OK
# Se cambia el avatar
signal changed_avatar
# Pasa al siguiente texto
signal changed_text # OK
# Se actualiza el texto (por cada letra)
signal updated_text # OK
# Comienza el dialogo
signal start_dialog # OK
signal end_section # OK
# Termina el dialogo
signal end_dialog # OK
signal empty_dialog

var next_pressed = false
