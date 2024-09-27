extends Panel
class_name RankingRow

@export var ordinal: String
@export var rank_name: String
@export var score: int
@export var time: int


func _ready():
	%LabelRank.text = ordinal
	%LabelName.text = rank_name
	%LabelScore.text = "%09d" % score
	%LabelTime.text = _transform_time(time)

func _transform_time(time: int) ->String:
	var sec = fmod(time, 60.0)
	var min = int(time / 60)
	return "%02d:%02d" % [min, sec]


func _on_focus_entered() -> void:
	modulate.v = 2
	var focus_tween = get_tree().create_tween()
	focus_tween.set_ease(Tween.EASE_IN)
	focus_tween.set_trans(Tween.TRANS_QUINT)
	focus_tween.tween_property(
	self, "modulate", Color(1,1,1,1), 0.1
	)


func _on_focus_exited() -> void:
	var focus_tween = get_tree().create_tween()
	focus_tween.set_ease(Tween.EASE_IN)
	focus_tween.set_trans(Tween.TRANS_QUINT)
	focus_tween.tween_property(
	self, "modulate", Color(1,1,1,0.9), 0.5
	)
