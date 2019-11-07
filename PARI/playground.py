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
"""
line2 = []
line3 = []
line5 = []
line7 = []
line11 = []
line13 = []

for i in range(1, len(data["farey"]["minDenom"])-1):
	if data["farey"]["minDenom"][i] == 13 * data["n"][i]:
		# line13.append(data["farey"]["minDenom"][i])
		line13.append(data["n"][i])
	elif data["farey"]["minDenom"][i] == 11 * data["n"][i]:
		# line11.append(data["farey"]["minDenom"][i])
		line11.append(data["n"][i])
	elif data["farey"]["minDenom"][i] == 7 * data["n"][i]:
		# line7.append(data["farey"]["minDenom"][i])
		line7.append(data["n"][i])
	elif data["farey"]["minDenom"][i] == 5 * data["n"][i]:
		# line5.append(data["farey"]["minDenom"][i])
		line5.append(data["n"][i])
	elif data["farey"]["minDenom"][i] == 3 * data["n"][i]:
		# line3.append(data["farey"]["minDenom"][i])
		line3.append(data["n"][i])
	elif data["farey"]["minDenom"][i] == 2 * data["n"][i]:
		# line2.append(data["farey"]["minDenom"][i])
		line2.append(data["n"][i])
	else:
		continue

lines = [line2, line3, line5, line7, line11, line13]

for line in lines:
	print(str(len(line)) + ": " + str(line))
"""
# maxi = (0, data["binary"]["maxDenom"][0])
myl = []
diff = []
for i in range(1, len(data["binary"]["maxDenom"])-1):
	if data["binary"]["minTerms"][i] == 3:
		myl.append(data["n"][i])
rc
print(str(len(myl)) + ": " + str(myl))
print(str(len(diff)) + ": " + str(diff))
		
# print(str(maxi) + "; " + str(maxi[0]^2 > maxi[1]))
# for i in range(9995, 9999):
# 	print(str(i) + ": " + str(data["binary"][""]))
