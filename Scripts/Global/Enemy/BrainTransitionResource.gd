class_name BrainTransition extends Resource

enum Operator {ALL_TRUE, ONE_OR_MORE_TRUE, NONE_TRUE};
enum Condition {HEALTH_PERCENTAGE_LESS, TIME_ELAPSED, PLAYER_WITHIN_DISTANCE, DEATH}
@export var cond : Array[Condition];
@export var values : Array[float];
@export var operator : Operator;
