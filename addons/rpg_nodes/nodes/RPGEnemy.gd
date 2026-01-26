# MIT License
#
# Copyright (c) 2025 - 2026 Matías Muñoz Espinoza
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

@icon("res://addons/rpg_nodes/icons/RPGEnemy.png")

class_name RPGEnemy extends RPGActor


## Energy or mana
@export var energy := 10:
	set(value):
		energy = clamp(value, 0, energy_max)
	get:
		return energy


@export var energy_max := 10:
	set(value):
		energy_max = clamp(value, 1, MAX_VALUE)
	get:
		return energy_max

@export var base_attack := 1

@export var exp_drop := 1


## Obtain the basic properties as a dictionary
func to_dict() -> Dictionary:
	return {
		"HP_MAX" = hp_max as int,
		"HP" = hp as int,
		"IS_DEAD" = is_dead as bool,
		
		"ENERGY_MAX" = energy_max as float,
		"ENERGY" = energy as int,
		
		"BASE_ATTACK"= base_attack as int,
		
		"EXP_DROP" = exp_drop as int
	}


## Create a new RPGEnemy from a dictionary data.
## You can use the to_dict() to inverse process.
func from_dict(data: Dictionary) -> void:
	if not _validate_rpgenemy_dict_data(data):
		return
	
	for key : String in data.keys():
		set(StringName(key.to_lower()), data[key])


#region PRIVATE

## Validate if data is a valid dictionary to be passed to
## from_dict()
func _validate_rpgenemy_dict_data(data: Dictionary) -> bool:
	var required_keys = [
		"HP", "HP_MAX", "IS_DEAD",
		"ENERGY", "ENERGY_MAX",
		"BASE_ATTACK", "EXP_DROP"
	]
	
	return required_keys.all(func(key): return data.has(key))

#endregion
