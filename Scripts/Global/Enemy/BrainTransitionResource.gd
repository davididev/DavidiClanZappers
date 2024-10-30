class_name BrainTransition extends Resource

enum Condition {HEALTH_PERCENTAGE, TIME_ELAPSED, PLAYER_WITHIN_DISTANCE, DEATH}
@export var cond : Condition;
@export var values : Array[float];
