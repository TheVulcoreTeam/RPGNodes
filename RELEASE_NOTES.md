# Release Notes

## [v0.10.0] - 2025-01-25

### Added

*   **Complete Slot-Based Inventory System**:
	*   **RPGSlotInventory**: Diablo-style grid inventory with configurable dimensions, auto-positioning algorithm, manual positioning support, collision detection, and comprehensive signal system.
	*   **RPGSlotItem**: Items with spatial properties (width/height) for grid-based inventory systems with position tracking and boundary validation.

*   **Fully Functional RPGStats System**:
	*   **RPGStats**: Complete character stat management with dynamic stat addition, stat points allocation, base vs. current stat tracking, and serialization support (to_dict/from_dict).
	*   Predefined stats: strength, dexterity, health with extensibility for custom stats.

*   **Enhanced Base Classes**:
	*   **RPGActor**: Abstract base class for all actor-like entities providing common actor functionality.
	*   **RPGEnemy**: Specific implementation for enemy characters inheriting from RPGActor.

*   **Improved Character System**:
	*   Enhanced serialization support for RPGCharacter with dictionary-based save/load functionality.
	*   Comprehensive experience and leveling system with energy and stamina management.

*   **Architecture Improvements**:
	*   Better inheritance hierarchy with proper base classes.
	*   Enhanced error handling and validation across all systems.
	*   Improved API consistency across all classes.

### Changed

*   **Project Architecture**: Updated to use proper inheritance patterns with RPGActor and RPGNode base classes.
*   **API Consistency**: Standardized method names and signal patterns across all classes.
*   **Test Coverage**: Added extensive unit tests for all new features (RPGSlotInventory: 245 lines, RPGStats: 251 lines).

### Fixed

*   **TODO Items Resolved**:
	*   Complete implementation of slot-based inventory system.
	*   Full functionality for RPGStats system (previously marked as TODO).
*   **Enhanced Validation**: Better boundary checking and collision detection in inventory systems.
*   **Serialization**: Robust save/load functionality for character and stats data.

### Breaking Changes

*   **Base Class Updates**: New inheritance hierarchy (RPGActor, RPGNode) may require code updates for existing implementations.
*   **Enhanced Serialization**: Updated serialization methods for better data consistency.
*   **API Refinements**: Some method signatures updated for consistency across the framework.

---

## [v0.9.0] - 2025-12-24

### Added

*   **New Item Properties**:
	*   **RPGPotion**: Added properties `effect_type` (Enum: HEALTH, MANA, SATURATION), `value` (int), and `duration` (float).
	*   **RPGShield**: Added properties `defense` (int) and `block_chance` (float).
	*   **RPGWeapon**: Added properties `damage` (int), `attack_speed` (float), and `crit_chance` (float).

*   **Documentation**:
	*   Updated `README.md` with detailed documentation for the new classes and properties.
	*   Added `README_ES.md` offering full documentation in Spanish.

*   **Tests**:
	*   Added Unit Tests (GUT) for `RPGPotion`, `RPGShield`, and `RPGWeapon` to verify default values, setters, and signal emissions.
