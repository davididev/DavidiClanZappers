class_name ObtainDialogueMeta extends Node


static func GetMeta(command_str : String) -> DialogueNodeMetaData:
	if command_str == "str":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_DialogueBox.tres");
	if command_str == "choice":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_Choice.tres");
	if command_str == "setvar":
		return ResourceLoader.load("res://DialogueSystem/meta/DialogueMeta_AlterVar.tres");
		
	return null;
