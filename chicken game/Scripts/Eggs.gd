extends RichTextLabel

var default_text = "Eggs: "

func _process(delta): #Displays the amount of eggs collected and the the amount left to collect
	var text = str(default_text, str(Global.points), "/", str(Global.num_egg))
	self.text = text

