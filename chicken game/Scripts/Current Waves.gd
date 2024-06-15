extends RichTextLabel

var default_text = "Current Wave: "

func _process(delta): #displays on the screen the number of wave
	var text = str(default_text, str(Global.curr_wave))
	self.text = text
