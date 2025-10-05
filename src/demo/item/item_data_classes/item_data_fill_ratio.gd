class_name ItemDataFillRatio


static func set_data(data: Dictionary, ratio: float):
	data["filled"]= ratio


static func parse_data(data: Dictionary)-> float:
	return data["filled"]
