extends ShopResourceBase
class_name ShopBuffResource

@export var buff_status_resource: PackedScene

func apply(character: CharacterBase) -> void:
	var status: Status = self.buff_status_resource.instantiate()
	character.status_component.add_status(status, character)
	GameManager.change_points_by(-self.cost)
