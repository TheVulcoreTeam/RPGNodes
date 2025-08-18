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

@icon("res://addons/rpg_nodes/icons/RPGCharacter.png")

extends RPGActor

class_name RPGCharacter

signal level_increased(new_level)
signal experience_gained(amount)
signal energy_replenished(amount)
signal energy_used(amount)
signal energy_reached_full()
## Emitted when energy drops to zero
signal energy_depleted()
signal stamina_replenished(amount)
signal stamina_used(amount)
signal stamina_reached_full()
## Emitted when stamina is completely exhausted
signal stamina_depleted()


@export var level_max := 30:
	set(value):
		level_max = value
	get:
		return level_max


## Energy or mana
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


@export var stamina := 20.0:
	set(value):
		var old_stamina := stamina
		var new_stamina := clamp(value, 0, stamina_max)
		
		if old_stamina < new_stamina:
			stamina = new_stamina
			stamina_replenished.emit(value)
		else:
			stamina = new_stamina
			stamina_used.emit(value)
		
		if new_stamina == stamina_max:
			stamina = new_stamina
			stamina_reached_full.emit()
		
		if new_stamina <= 0:
			stamina_depleted.emit()
	get:
		return stamina


@export var stamina_max := 20.0:
	set(value):
		stamina_max = clamp(value, 1.0, MAX_VALUE)
	get:
		return stamina_max


@export var stamina_regen_per_second := 2.0:
	set(value):
		stamina_regen_per_second = clamp(value, 1.0, stamina_max)
	get:
		return stamina_regen_per_second


@export var base_attack := 1

## Base constant that affect the progression
var experience_base := 100.0
## Factor to ajust the curve
var experience_factor := 1.5

## Variable to store the current experience
var _current_exp := 0.0
## Current level from the player
var _current_level := 1

## It's useful for stamina
var _time := 0.0

# TODO: Defence
# (factor_def/(current_def+factor_def))*damage


func _process(delta) -> void:
	_time += delta
	
	if _time >= 1:
		_time = 0.0
		stamina += stamina_regen_per_second


## Revive the player when is dead
func revive(custom_hp := 1, revive_with_max_hp := true) -> void:
	if not is_dead:
		self.message_sent.emit("You can't revive someone alive")
		return
	
	is_dead = false
	
	if revive_with_max_hp:
		hp = hp_max
	else:
		hp = custom_hp
	
	revived.emit()


## Get the experience for a specific level
func get_exp_for_level(level: int) -> float:
	# Use sqrt to create a grow curve
	return experience_base * pow(level, experience_factor) * sqrt(level)


## Get the total experience required for the current level
func get_total_exp_to_current_level() -> float:
	var total_exp = 0.0
	for lvl in range(1, _current_level):
		total_exp += get_exp_for_level(lvl)
	return total_exp


## Experience needed for the next level
func get_exp_to_next_level() -> float:
	return get_exp_for_level(_current_level)


## Add experience and level up if needed
func add_experience(amount: float) -> void:
	_current_exp += amount
	
	# Check whether it should level up.
	while _current_exp >= get_exp_to_next_level():
		experience_gained.emit(get_exp_to_next_level())
		
		_current_exp -= get_exp_to_next_level()
		
		_level_up()


## Is called when level up
func _level_up() -> void:
	_current_level += 1
	
	# You can connect a signal when level up
	level_increased.emit(_current_level)


## Return the percentage of progress toward the next level (0.0 - 1.0)
func get_level_progress() -> float:
	return _current_exp / get_exp_to_next_level()


## Reset level stats (current_level and current_exp)
func reset_level_stats() -> void:
	_current_level = 0
	_current_exp = 0.0
