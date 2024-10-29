class_name ObtainDialogueMeta extends Node


static func GetMeta(command_str : String) -> DialogueNodeMetaData:
	if command_str == "str":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_DialogueBox.tres");
	if command_str == "choice":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_Choice.tres");
	if command_str == "setvar":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_AlterVar.tres");
	if command_str == "ifthen":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_IfStatement.tres");
	if command_str == "var":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_AlterVar.tres");
	if command_str == "msg":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_SendMessage.tres");
	if command_str == "move":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_MoveToPoint.tres");
	if command_str == "wait":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_Wait.tres");
	if command_str == "flash":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_Flash.tres");
	if command_str == "snd":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_PlaySound.tres");
	if command_str == "mus":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_Music.tres");
	if command_str == "end":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_End.tres");
	if command_str == "sce":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_ChangeScene.tres");
	if command_str == "tel":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueTeleportActor.tres");
	if command_str == "ais":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_AddItemOrSpell.tres");
	if command_str == "cis":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_GetItemOrSpellCount.tres");
	return null;
