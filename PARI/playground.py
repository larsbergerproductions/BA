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
for i in range(8192, len(data["greedy"]["maxDenom"])-1):
	if data["binary"]["maxDenom"][i] < 1e6:
		print(str(data["n"][i]) + " : " + str(data["binary"]["maxDenom"][i]))
		if is_power_of_two(data["binary"]["maxDenom"][i]):
			print("is power of 2")
