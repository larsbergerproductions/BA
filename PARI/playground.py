import numpy as np
import json



def load_data_from_json():
	with open("data.json", 'r') as file:
		json_file = json.load(file)
	return json_file


def is_power_of_two(n):
	while n > 2:
		n /= 2
	if n == 2:
		return True
	else:
		return False


data = load_data_from_json()

for i in range(0, len(data["binary"]["minTerms"])-1):
	if data["binary"]["minDenom"][i] % 2 == 1:
		if data["binary"]["minDenom"][i] == data["farey"]["minDenom"][i]:
			print(data["n"][i])
