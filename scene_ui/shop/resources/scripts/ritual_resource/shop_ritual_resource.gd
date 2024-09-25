extends ShopResourceBase
class_name ShopRitualResource

@export_category("Ritual")
@export var cooldown: float
@export var scene: PackedScene

func apply(character: CharacterBase) -> void:
	character.skill_progress_bars.add_ritual(self)
	character.on_
