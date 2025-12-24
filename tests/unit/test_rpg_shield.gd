extends GutTest

var shield: RPGShield


func before_each():
	shield = RPGShield.new()


func after_each():
	shield = null


# Defense Tests
func test_defense_default_value():
	assert_eq(shield.defense, 0, "Default defense should be 0")


func test_defense_can_be_set():
	shield.defense = 10
	assert_eq(shield.defense, 10, "Should be able to set defense")


func test_defense_signal_emitted():
	watch_signals(shield)
	shield.defense = 5
	assert_signal_emitted(shield, "defense_changed", "Signal should be emitted when defense changes")


# Block Chance Tests
func test_block_chance_default_value():
	assert_eq(shield.block_chance, 0.0, "Default block_chance should be 0.0")


func test_block_chance_can_be_set():
	shield.block_chance = 0.5
	assert_eq(shield.block_chance, 0.5, "Should be able to set block_chance")


func test_block_chance_signal_emitted():
	watch_signals(shield)
	shield.block_chance = 0.2
	assert_signal_emitted(shield, "block_chance_changed", "Signal should be emitted when block_chance changes")
