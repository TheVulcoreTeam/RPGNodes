# MIT License
#
# Copyright (c) 2018 - 2025 Matías Muñoz Espinoza
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

extends RPGActor

class_name RPGCharacter

signal level_increased(new_level)
signal xp_added(amount)
signal energy_added(amount)
signal energy_removed(amount)
signal energy_is_full()
signal energy_without()
signal stamine_added(amount)
signal stamine_removed(amount)
signal stamine_is_full()
signal stamine_without()


@export var level_max := 30:
	set(value):
		level_max = value
	get:
		return level_max

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

@export var stamine := 20.0:
	set(value):
		var old_stamine := stamine
		var new_stamine := clamp(value, 0, stamine_max)
		
		if old_stamine < new_stamine:
			stamine = new_stamine
			stamine_added.emit(value)
		else:
			stamine = new_stamine
			stamine_removed.emit(value)
		
		if new_stamine == stamine_max:
			stamine = new_stamine
			stamine_is_full.emit()
		
		if new_stamine <= 0:
			stamine_without.emit()
	get:
		return stamine

@export var stamine_max := 20.0:
	set(value):
		stamine_max = clamp(value, 1.0, MAX_VALUE)
	get:
		return stamine_max

@export var stamine_regen_per_second := 2.0:
	set(value):
		stamine_regen_per_second = clamp(value, 1.0, stamine_max)
	get:
		return stamine_regen_per_second

@export var base_attack := 1

# Constante base que afecta la progresión
var experience_base := 100.0
# Factor que ajusta la curva
var experience_factor := 1.5

# Variable para almacenar la experiencia actual
var current_exp := 0.0
# Nivel actual del jugador
var current_level := 1

# Is util for stamine
var time := 0.0


func _process(delta) -> void:
	time += delta
	
	if time >= 1:
		time = 0.0
		stamine += stamine_regen_per_second


func revive(custom_hp := 1, revive_with_max_hp := true) -> void:
	if not is_dead:
		message.emit("You can't revive someone alive")
		return
	
	is_dead = false
	
	if revive_with_max_hp:
		hp = hp_max
	else:
		hp = custom_hp
	
	revived.emit()


# Calcula la experiencia necesaria para alcanzar un nivel específico
func get_exp_for_level(level: int) -> float:
	# Usando sqrt para crear una curva de crecimiento
	return experience_base * pow(level, experience_factor) * sqrt(level)


# Calcula la experiencia total necesaria hasta el nivel actual
func get_total_exp_to_current_level() -> float:
	var total_exp = 0.0
	for lvl in range(1, current_level):
		total_exp += get_exp_for_level(lvl)
	return total_exp


# Experiencia necesaria para el siguiente nivel
func get_exp_to_next_level() -> float:
	return get_exp_for_level(current_level)


# Agrega experiencia y sube de nivel si es necesario
func add_experience(amount: float) -> void:
	current_exp += amount
	
	# Comprueba si se debe subir de nivel
	while current_exp >= get_exp_to_next_level():
		xp_added.emit(get_exp_to_next_level())
		
		current_exp -= get_exp_to_next_level()
		
		level_up()


# Función llamada al subir de nivel
func level_up() -> void:
	current_level += 1
	
	# Aquí puedes emitir una señal para actualizar la UI
	level_increased.emit(current_level)


# Retorna el porcentaje de progreso hacia el siguiente nivel (0.0 - 1.0)
func get_level_progress() -> float:
	return current_exp / get_exp_to_next_level()


func reset_level_stats() -> void:
	current_level = 0
	current_exp = 0.0
