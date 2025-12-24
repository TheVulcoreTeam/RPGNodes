# Release Notes

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
