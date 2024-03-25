# MIT License
#
# RPGNodes
#
# Copyright (c) 2018 - 2024 Matías Muñoz Espinoza
# Copyright (c) 2018 Jovani Pérez
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

class_name RPGCharacter

const MAX_VALUE = 100000

signal level_increased(new_level)
signal xp_added(amount)
signal xp_droped(amount)
signal hp_added(amount)
signal hp_removed(amount)
signal hp_is_full()
signal died()
signal revived()
signal energy_added(amount)
signal energy_removed(amount)
signal energy_is_full()
signal energy_without()

# TODO: Falta implementar los métodos add_defense, remove_defense
# signal add_defense # TODO
# signal remove_defense # TODO

@export var character_name := ""

@export var level := 0:
	set(value):
		level = clamp(value, 0, level_max)
	get:
		return level

@export var level_max := 30:
	set(value):
		level_max = value
	get:
		return level_max

# Vitality
@export var hp := 20:
	set(value):
		if not is_dead:
			hp = clamp(value, 0, hp_max)
			
			if value > 0 and hp == hp_max:
				hp_is_full.emit()
			elif value > 0 and hp != hp_max:
				hp_added.emit()
			elif value < 0 and hp != 0:
				hp_removed.emit()
			
			if hp == 0:
				is_dead = true
				died.emit()
		else:
			self.message.emit("I am die: " + name + " " + character_name)
	get:
		return hp

@export var hp_max := 20:
	set(value):
		hp_max = clamp(value, 1, MAX_VALUE)
	get:
		return hp_max

# Energy or mana
@export var energy := 20:
	set(value):
		energy = clamp(value, 0, energy_max)
	get:
		return energy

@export var energy_max := 20:
	set(value):
		energy_max = clamp(value, 1, MAX_VALUE)
	get:
		return energy_max

# 0% de defense
# @export var defense_rate := 0
# TODO: Implementar escudo
# export (int) var shield

@export var attack := 1

var xp := 0:
	set(value):
		if is_dead:
			return
		
		if value > 0:
			xp_total += value
			xp += value
			
			while xp >= xp_required:
				xp -= xp_required
				
				xp_added.emit(xp_required)
				
				if level < level_max:
					level_up()
				else:
					self.message.emit("I can't level_up because my level is " + str(level_max))
		elif value == 0:
			xp = 0
	get:
		return xp

var xp_required := 0:
	set(value):
		xp_required = value
	get:
		return int(round(pow(level, 1.8) + level * 4))

var xp_total := 0:
	set(value):
		xp_total = value
	get:
		return xp_total

var xp_drop_amount := 0

# Previene que muera más de una vez. Esto hace que el player
# no pueda ganar/perder vida/energía cuando esta muerto.
# Para revivirlo se debe utilizar revive().
# El character si puede ganar experiencia cuando esta muerto,
# la razón es que a veces se da experiencia al jugador cuando
# no se esta en la pantalla de juego. 
var is_dead := false


func revive(revive_with_max_hp := true):
	if not is_dead:
		message.emit("You can't revive someone alive")
		return
	
	is_dead = false
	
	if revive_with_max_hp:
		hp = hp_max
	else:
		hp = 1
	
	revived.emit()


func level_up():
	level += 1
	xp_required = xp_required_to_level(level + 1)
	
	level_increased.emit(level)


func xp_required_to_level(_level) -> int:
	return int(round(pow(_level, 1.8) + _level * 4))


func reset_stats():
	level = 0
	xp_required = 0
	xp_total = 0
	xp = 0
