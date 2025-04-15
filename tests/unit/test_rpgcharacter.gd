extends GutTest

var character: RPGCharacter


func before_each():
	# Configurar el entorno de prueba antes de cada test
	character = RPGCharacter.new()
	character.character_name = "Test Character"
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
	var expected_remainder = exp_to_level_4
	assert_almost_eq(character.current_exp, expected_remainder, 0.001, "La experiencia sobrante debe mantenerse")


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
	assert_signal_emitted_with_parameters(character, "message", ["You can't revive someone alive"])


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
	character.stamine = 10
	assert_eq(character.stamine, 10, "La resistencia debe disminuir correctamente")
	assert_signal_emitted(character, "stamine_removed")
	
	# Aumentar resistencia
	character.stamine = 15
	assert_eq(character.stamine, 15, "La resistencia debe aumentar correctamente")
	assert_signal_emitted(character, "stamine_added")
	
	# Resistencia máxima
	character.stamine = character.stamine_max
	assert_signal_emitted(character, "stamine_is_full")
	
	# Sin resistencia
	character.stamine = 0
	assert_signal_emitted(character, "stamine_without")


func test_stamina_regeneration():
	# Simulamos la recuperación de resistencia
	character.stamine = 10
	
	# Simulamos el paso de tiempo
	character.time = 0.9
	character._process(0.2)  # Esto debería hacer que time >= 1
	
	assert_eq(character.stamine, 12, "La resistencia debe regenerarse según la tasa de regeneración")
	assert_almost_eq(character.time, 0.0, 0.001, "El tiempo debe reiniciarse después de la regeneración")


# Test para reset de estadísticas
func test_reset_stats():
	character.current_level = 10
	character.current_exp = 150.0
	
	character.reset_stats()
	
	assert_eq(character.current_level, 0, "El nivel actual debe reiniciarse a 0")
	assert_eq(character.current_exp, 0.0, "La experiencia debe reiniciarse a 0")


# Test para valores límite
func test_value_limits():
	character.hp_max = RPGCharacter.MAX_VALUE + 1000
	assert_eq(character.hp_max, RPGCharacter.MAX_VALUE, "HP máximo no debe exceder MAX_VALUE")
	
	character.energy_max = -10
	assert_eq(character.energy_max, 1, "Energy máximo no debe ser menor que 1")
