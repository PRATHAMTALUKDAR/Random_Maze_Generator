extends TextEdit

func _ready():
	pass

func _process(_delta):
	text = str(Performance.get_monitor(Performance.TIME_FPS))+"FPS"
