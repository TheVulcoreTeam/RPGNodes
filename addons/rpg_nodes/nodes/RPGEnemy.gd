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
func get_dictionary() -> Dictionary:
	return {
		"HP_MAX" = hp_max as int,
		"HP" = hp as int,
		"IS_DEAD" = is_dead as bool,
		
		"ENERGY_MAX" = energy_max as float,
		"ENERGY" = energy as int,
		
		"BASE_ATTACK"= base_attack as int,
		
		"EXP_DROP" = exp_drop as int
	}


## Create a new RPGEnemy from a dictionary rpgenemy_dict_data.
## You can use the get_dictionary() to inverse process.
func get_rpgenemy_from_dictionary(rpgenemy_dict_data : Dictionary) -> RPGEnemy:
	if not _validate_rpgenemy_dict_data(rpgenemy_dict_data):
		return RPGEnemy.new()
	
	var rpgenemy := RPGEnemy.new()
	
	for key : String in rpgenemy_dict_data.keys():
		rpgenemy.set(StringName(key.to_lower()), rpgenemy_dict_data[key])
	
	return rpgenemy


#region PRIVATE

## Validate if rpgenemy_dict_data is a valid dictionary to be pased to
## get_rpgenemy_from_dictionary()
func _validate_rpgenemy_dict_data(rpgenemy_dict_data: Dictionary) -> bool:
	var required_keys = [
		"HP", "HP_MAX", "IS_DEAD",
		"ENERGY", "ENERGY_MAX",
		"BASE_ATTACK", "EXP_DROP"
	]
	
	return required_keys.all(func(key): return rpgenemy_dict_data.has(key))

#endregion
