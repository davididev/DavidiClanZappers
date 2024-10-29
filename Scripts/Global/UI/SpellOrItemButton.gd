extends Node

@export var isItem = true;
@export var dataID = 0;
var itemID = -1;
var spellID = -1;

#Called when the inventory menu is open
func RedrawButton():
	itemID = -1;
	spellID = -1;
	if isItem:
		itemID = GameDataHolder.Instance.data.Items[dataID];
		get_node("TextureRect").texture = load(str("res://Graphics/UI/Inventory/Item", itemID, ".png"))
	else:
		spellID = GameDataHolder.Instance.data.Spells[dataID];
		get_node("TextureRect").texture = load(str("res://Graphics/UI/Inventory/Spell", itemID, ".png"))


func _on_pressed() -> void:
	pass # Replace with function body.
