extends GutTest

var character: RPGCharacter


func before_each():
	# Configurar el entorno de prueba antes de cada test
	character = RPGCharacter.new()
	character.actor_name = "Test Character"
	add_child(character)


func after_each():
	# Limpiar después de cada test
	character.queue_free()
	character = null


# Tests para el sistema de experiencia
func test_initial_exp_values():
	assert_eq(character.current_exp, 0.0, "El personaje debe comenzar con 0 EXP")
	assert_eq(character.current_level, 1, "El personaje debe comenzar en nivel 1")
	assert_eq(character.get_level_progress(), 0.0, "El progreso inicial debe ser 0")


func test_exp_calculation():
	var exp_level_1 = character.get_exp_for_level(1)
	var exp_level_2 = character.get_exp_for_level(2)
	
	# Verificamos que la experiencia aumente con cada nivel
	assert_true(exp_level_2 > exp_level_1, "La experiencia requerida debe aumentar por nivel")
	
	# Verificamos que la fórmula funcione correctamente
	var expected_exp = character.experience_base * pow(2, character.experience_factor) * sqrt(2)
	assert_almost_eq(exp_level_2, expected_exp, 0.001, "La fórmula de EXP debe calcular correctamente")


func test_add_experience():
	watch_signals(character)
	
	# Obtenemos la EXP necesaria para nivel 2
	var exp_needed = character.get_exp_for_level(1)
	
	# Añadimos experiencia insuficiente para subir de nivel
	character.add_experience(exp_needed * 0.5)
	assert_eq(character.current_level, 1, "No debe subir de nivel con experiencia insuficiente")
	assert_almost_eq(character.current_exp, exp_needed * 0.5, 0.001, "La experiencia debe acumularse correctamente")
	
	# Añadimos el resto para subir de nivel
	character.add_experience(exp_needed * 0.5)
	assert_eq(character.current_level, 2, "Debe subir a nivel 2")
	assert_almost_eq(character.current_exp, 0.0, 0.001, "La experiencia debe reiniciarse al subir de nivel")


func test_multiple_level_ups():
	# Experiencia para llegar al nivel 2
	var exp_to_level_2 = character.get_exp_for_level(1)
	# Experiencia para llegar al nivel 3
	var exp_to_level_3 = character.get_exp_for_level(2)
	# Experiencia para llegar al nivel 4
	var exp_to_level_4 = character.get_exp_for_level(3)
	
	# Añadimos experiencia para subir varios niveles de una vez
	character.add_experience(exp_to_level_2 + exp_to_level_3 + exp_to_level_4)
	
	assert_eq(character.current_level, 4, "Debe subir múltiples niveles")


# Tests para HP y estado de muerte
func test_hp_management():
	watch_signals(character)
	
	# Verificar valores iniciales
	assert_eq(character.hp, 20, "HP inicial debe ser 20")
	assert_eq(character.hp_max, 20, "HP máximo inicial debe ser 20")
	assert_false(character.is_dead, "El personaje no debe estar muerto inicialmente")
	
	# Quitar HP
	character.hp -= 5
	assert_eq(character.hp, 15, "HP debe disminuir correctamente")
	assert_signal_emitted(character, "hp_removed")
	
	# Añadir HP
	character.hp += 3
	assert_eq(character.hp, 18, "HP debe aumentar correctamente")
	assert_signal_emitted(character, "hp_added")
	
	# HP máximo
	character.hp = character.hp_max
	assert_signal_emitted(character, "hp_is_full")
	
	# Matar al personaje
	character.hp = 0
	assert_true(character.is_dead, "El personaje debe morir al llegar a 0 HP")
	assert_signal_emitted(character, "died")


func test_revive():
	watch_signals(character)
	
	# Matar al personaje
	character.hp = 0
	assert_true(character.is_dead, "El personaje debe estar muerto")
	
	# Intentar curar cuando está muerto
	character.hp += 10
	assert_eq(character.hp, 0, "El personaje muerto no debe poder curarse")
	
	# Revivir con HP personalizado
	character.revive(5, false)
	assert_false(character.is_dead, "El personaje debe estar vivo tras revivir")
	assert_eq(character.hp, 5, "El HP debe ser el especificado al revivir")
	assert_signal_emitted(character, "revived")
	
	# Revivir con HP máximo
	character.hp = 0
	character.is_dead = true
	character.revive()
	assert_eq(character.hp, character.hp_max, "Debe revivir con HP máximo por defecto")


func test_cannot_revive_alive():
	watch_signals(character)
	
	# Intentar revivir estando vivo
	character.revive()
	assert_signal_emitted_with_parameters(character, "message_sent", ["You can't revive someone alive"])


# Tests para energía
func test_energy_management():
	watch_signals(character)
	
	character.energy = 10
	assert_eq(character.energy, 10, "La energía debe actualizarse correctamente")
	
	character.energy = -5
	assert_eq(character.energy, 0, "La energía no debe ser negativa")
	
	character.energy = character.energy_max + 10
	assert_eq(character.energy, character.energy_max, "La energía no debe exceder el máximo")


# Tests para resistencia (stamina)
func test_stamina_management():
	watch_signals(character)
	
	# Disminuir resistencia
	character.stamina = 10
	assert_eq(character.stamina, 10, "La resistencia debe disminuir correctamente")
	assert_signal_emitted(character, "stamina_used")
	
	# Aumentar resistencia
	character.stamina = 15
	assert_eq(character.stamina, 15, "La resistencia debe aumentar correctamente")
	assert_signal_emitted(character, "stamina_replenished")
	
	# Resistencia máxima
	character.stamina = character.stamina_max
	assert_signal_emitted(character, "stamina_reached_full")
	
	# Sin resistencia
	character.stamina = 0
	assert_signal_emitted(character, "stamina_depleted")


func test_stamina_regeneration():
	# Simulamos la recuperación de resistencia
	character.stamina = 10
	
	# Simulamos el paso de tiempo
	character._time = 0.9
	character._process(0.2)  # Esto debería hacer que time >= 1
	
	assert_eq(character.stamina, 12, "La resistencia debe regenerarse según la tasa de regeneración")
	assert_almost_eq(character._time, 0.0, 0.001, "El tiempo debe reiniciarse después de la regeneración")


# Test para reset de estadísticas
func test_reset_stats():
	character.current_level = 10
	character.current_exp = 150.0
	
	character.reset_level_stats()
	
	assert_eq(character.current_level, 0, "El nivel actual debe reiniciarse a 0")
	assert_eq(character.current_exp, 0.0, "La experiencia debe reiniciarse a 0")


# Test para valores límite
func test_value_limits():
	character.hp_max = RPGCharacter.MAX_VALUE + 1000
	assert_eq(character.hp_max, RPGCharacter.MAX_VALUE, "HP máximo no debe exceder MAX_VALUE")
	
	character.energy_max = -10
	assert_eq(character.energy_max, 1, "Energy máximo no debe ser menor que 1")


func test_get_dictionary_returns_expected_keys_and_types():
	var rpg = RPGCharacter.new()
	
	rpg.hp_max = 100
	rpg.hp = 100
	rpg.is_dead = false
	rpg.current_level = 5
	rpg.level_max = 50
	rpg.current_exp = 123.45
	rpg.energy_max = 100.0
	rpg.energy = 60
	rpg.stamina_max = 100.0
	rpg.stamina = 80.5
	rpg.stamina_regen_per_second = 2.5
	rpg.base_attack = 20
	rpg.experience_base = 100.0
	rpg.experience_factor = 1.5
	
	var dict = rpg.get_dictionary()
	
	var expected_keys = [
		"HP", "HP_MAX", "IS_DEAD",
		"CURRENT_LEVEL", "LEVEL_MAX",
		"CURRENT_EXP",
		"ENERGY", "ENERGY_MAX",
		"STAMINA", "STAMINA_MAX", "STAMINA_REGEN_PER_SECOND",
		"BASE_ATTACK",
		"EXPERIENCE_BASE", "EXPERIENCE_FACTOR"
	]
	
	for key in expected_keys:
		assert_true(dict.has(key), "not found the key: %s" % key)
	
	# Verify types
	assert_eq(dict["HP"], 100, "HP should be int")
	assert_eq(dict["HP_MAX"], 100, "HP_MAX should be int")
	assert_eq(dict["IS_DEAD"], false, "IS_DEAD should be bool")
	assert_eq(dict["CURRENT_LEVEL"], 5, "CURRENT_LEVEL should be int")
	assert_eq(dict["LEVEL_MAX"], 50, "LEVEL_MAX should be int")
	assert_eq(dict["CURRENT_EXP"], 123.45, "CURRENT_EXP should be float")
	assert_eq(dict["ENERGY"], 60, "ENERGY should be int")
	assert_eq(dict["ENERGY_MAX"], 100.0, "ENERGY_MAX should be float")
	assert_eq(dict["STAMINA"], 80.5, "STAMINA should be float")
	assert_eq(dict["STAMINA_MAX"], 100.0, "STAMINA_MAX should be float")
	assert_eq(dict["STAMINA_REGEN_PER_SECOND"], 2.5, "STAMINA_REGEN_PER_SECOND should be float")
	assert_eq(dict["BASE_ATTACK"], 20, "BASE_ATTACK should be int")
	assert_eq(dict["EXPERIENCE_BASE"], 100.0, "EXPERIENCE_BASE should be float")
	assert_eq(dict["EXPERIENCE_FACTOR"], 1.5, "EXPERIENCE_FACTOR should be float")


func test_get_rpgcharacter_from_dictionary_with_valid_data():
	var original = RPGCharacter.new()
	original.hp_max = 100
	original.hp = 90
	original.is_dead = false
	original.level_max = 100
	original.current_level = 3
	original.current_exp = 250.0
	original.energy_max = 80.0
	original.energy = 50
	original.stamina_max = 90.0
	original.stamina = 70.0
	original.stamina_regen_per_second = 1.2
	original.base_attack = 15
	original.experience_base = 100.0
	original.experience_factor = 1.3
	
	var dict = original.get_dictionary()
	var restored = original.get_rpgcharacter_from_dictionary(dict)
	
	# Verify that values were correctly restored
	assert_eq(restored.hp, 90)
	assert_eq(restored.hp_max, 100)
	assert_eq(restored.is_dead, false)
	assert_eq(restored.current_level, 3)
	assert_eq(restored.level_max, 100)
	assert_eq(restored.current_exp, 250.0)
	assert_eq(restored.energy, 50)
	assert_eq(restored.energy_max, 80.0)
	assert_eq(restored.stamina, 70.0)
	assert_eq(restored.stamina_max, 90.0)
	assert_eq(restored.stamina_regen_per_second, 1.2)
	assert_eq(restored.base_attack, 15)
	assert_eq(restored.experience_base, 100.0)
	assert_eq(restored.experience_factor, 1.3)
