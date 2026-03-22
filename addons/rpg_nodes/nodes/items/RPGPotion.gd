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

@icon("res://addons/rpg_nodes/icons/RPGItem.png")
extends RPGWeightItem
class_name RPGPotion


enum PotionEffect {HEALTH, MANA, SATURATION}


signal effect_type_changed(old_value, new_value)
signal value_changed(old_value, new_value)
signal duration_changed(old_value, new_value)


## Potion effect type
@export var effect_type: PotionEffect = PotionEffect.HEALTH:
	set(val):
		if effect_type != val:
			effect_type_changed.emit(effect_type, val)
			effect_type = val
	get:
		return effect_type


## Effect value
@export var value := 0:
	set(val):
		if value != val:
			value_changed.emit(value, val)
			value = val
	get:
		return value


## Effect duration
@export var duration := 0.0:
	set(val):
		if duration != val:
			duration_changed.emit(duration, val)
			duration = val
	get:
		return duration
