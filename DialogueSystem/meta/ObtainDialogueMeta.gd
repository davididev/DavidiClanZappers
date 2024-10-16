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
	return null;
