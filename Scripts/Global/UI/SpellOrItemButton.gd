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
		get_node("TextureRect").texture = load(str("res://Graphics/UI/Inventory/Spell", spellID, ".png"))


func _on_pressed() -> void:
	if isItem:
		Avatar.AttachedItem = itemID;
		get_tree().get_first_node_in_group("Player").call("AttachItem");
		SoundFXPlayer.PlaySound("interface/confirmation_002.ogg", get_tree(), Avatar.PlayerPos);
	else:
		Avatar.AttachedSpell = spellID;
		get_tree().get_first_node_in_group("Player").call("AttachSpell");
		SoundFXPlayer.PlaySound("interface/confirmation_001.ogg", get_tree(), Avatar.PlayerPos);
		PlayerUI.UpdateHUD = true;

	var offset = Vector2(24.0, 24.0)
	get_parent().get_parent_control().RunArmed(self.global_position + offset);
