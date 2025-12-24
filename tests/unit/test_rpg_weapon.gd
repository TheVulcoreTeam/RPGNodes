extends GutTest

var weapon: RPGWeapon


func before_each():
	weapon = RPGWeapon.new()


func after_each():
	weapon = null


# Damage Tests
func test_damage_default_value():
	assert_eq(weapon.damage, 0, "Default damage should be 0")


func test_damage_can_be_set():
	weapon.damage = 25
	assert_eq(weapon.damage, 25, "Should be able to set damage")


func test_damage_signal_emitted():
	watch_signals(weapon)
	weapon.damage = 15
	assert_signal_emitted(weapon, "damage_changed", "Signal should be emitted when damage changes")


# Attack Speed Tests
func test_attack_speed_default_value():
	assert_eq(weapon.attack_speed, 1.0, "Default attack_speed should be 1.0")


func test_attack_speed_can_be_set():
	weapon.attack_speed = 1.5
	assert_eq(weapon.attack_speed, 1.5, "Should be able to set attack_speed")


func test_attack_speed_signal_emitted():
	watch_signals(weapon)
	weapon.attack_speed = 1.2
	assert_signal_emitted(weapon, "attack_speed_changed", "Signal should be emitted when attack_speed changes")


# Crit Chance Tests
func test_crit_chance_default_value():
	assert_eq(weapon.crit_chance, 0.0, "Default crit_chance should be 0.0")


func test_crit_chance_can_be_set():
	weapon.crit_chance = 0.25
	assert_eq(weapon.crit_chance, 0.25, "Should be able to set crit_chance")


func test_crit_chance_signal_emitted():
	watch_signals(weapon)
	weapon.crit_chance = 0.1
	assert_signal_emitted(weapon, "crit_chance_changed", "Signal should be emitted when crit_chance changes")
