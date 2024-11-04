extends Area3D

@export var goldAmount = 1;
@export var healPercentage = 0;
@export var soundFX : String = "rpg/handleCoins.ogg";

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(60) * delta);


func _on_body_entered(body: Node3D) -> void:
	if visible == true:
		if body.is_in_group("Player"):
			GameDataHolder.Instance.data.Gold += goldAmount;
			var amt = GameDataHolder.Instance.data.MaxHealth * healPercentage / 100;
			if amt > 0:
				if(body.has_method("Heal")):
					body.call("Heal", amt);
			PlayerUI.UpdateHUD = true;
			SoundFXPlayer.PlaySound(soundFX, get_tree(), global_position);
			Node3DPool.SetActive(self, false);
