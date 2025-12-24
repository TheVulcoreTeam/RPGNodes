extends GutTest

var potion: RPGPotion


func before_each():
	potion = RPGPotion.new()


func after_each():
	potion = null


# Effect Type Tests
func test_effect_type_default_value():
	assert_eq(potion.effect_type, RPGPotion.PotionEffect.HEALTH, "Default effect type should be HEALTH")


func test_effect_type_can_be_set():
	potion.effect_type = RPGPotion.PotionEffect.MANA
	assert_eq(potion.effect_type, RPGPotion.PotionEffect.MANA, "Should be able to set effect type")


func test_effect_type_signal_emitted():
	watch_signals(potion)
	potion.effect_type = RPGPotion.PotionEffect.SATURATION
	assert_signal_emitted(potion, "effect_type_changed", "Signal should be emitted when effect type changes")


# Value Tests
func test_value_default_value():
	assert_eq(potion.value, 0, "Default value should be 0")


func test_value_can_be_set():
	potion.value = 50
	assert_eq(potion.value, 50, "Should be able to set value")


func test_value_signal_emitted():
	watch_signals(potion)
	potion.value = 25
	assert_signal_emitted(potion, "value_changed", "Signal should be emitted when value changes")


# Duration Tests
func test_duration_default_value():
	assert_eq(potion.duration, 0.0, "Default duration should be 0.0")


func test_duration_can_be_set():
	potion.duration = 10.5
	assert_eq(potion.duration, 10.5, "Should be able to set duration")


func test_duration_signal_emitted():
	watch_signals(potion)
	potion.duration = 5.0
	assert_signal_emitted(potion, "duration_changed", "Signal should be emitted when duration changes")
