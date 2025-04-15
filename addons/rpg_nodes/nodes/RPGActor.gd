# MIT License
#
# Copyright (c) 2025 Matías Muñoz Espinoza
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

class_name RPGActor

const MAX_VALUE = 100000

signal hp_added(amount)
signal hp_removed(amount)
signal hp_is_full()
signal died()
signal revived()

@export var actor_name := ""

# Health or vitality
@export var hp := 20:
	set(value):
		if not is_dead:
			var old_hp := hp
			var new_hp := clamp(value, 0, hp_max)
			
			if old_hp < new_hp:
				hp = new_hp
				hp_added.emit(value)
			else:
				hp = new_hp
				hp_removed.emit(value)
			
			if new_hp == hp_max:
				hp = new_hp
				hp_is_full.emit()
			
			if new_hp == 0:
				is_dead = true
				hp = new_hp
				died.emit()
		else:
			self.message.emit("I am die: " + name + " " + actor_name)
	get:
		return hp

@export var hp_max := 20:
	set(value):
		hp_max = clamp(value, 1, MAX_VALUE)
	get:
		return hp_max

# Previene que muera más de una vez. Esto hace que el player
# no pueda ganar/perder vida/energía cuando esta muerto.
# Para revivirlo se debe utilizar revive().
# El character si puede ganar experiencia cuando esta muerto,
# la razón es que a veces se da experiencia al jugador cuando
# no se esta en la pantalla de juego. 
var is_dead := false
