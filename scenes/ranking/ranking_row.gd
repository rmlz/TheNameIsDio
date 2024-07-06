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
