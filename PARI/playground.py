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
reslist = []
print(data["n"][0])
currmax = data["greedy"]["maxTerms"][0]
for i in range(0, len(data["greedy"]["maxDenom"])-1):
	if data["greedy"]["maxDenom"][i] < currmax:
		currmax = data["greedy"]["maxDenom"][i]
		# print("reset with " + str(currmax))
		print(data["n"][i])
print(currmax)
