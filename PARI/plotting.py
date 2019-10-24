from matplotlib import pyplot as plt
import matplotlib.ticker
import csv
import sys
import json
import numpy as np

csv.field_size_limit(sys.maxsize)

greedy_file = "results_greedy.csv"
farey_file = "results_fastfarey.csv"
binary_file = "results_binary.csv"
data_json_file = "data.json"


def write_data_to_json():
	greedy_rows = []
	farey_rows = []
	binary_rows = []
	
	print("reading data...")
	with open(greedy_file, 'r', newline='') as greedy_csv:
		csvreader = csv.reader(greedy_csv, delimiter=',')
		for row in csvreader:
			greedy_rows.append(row)
	with open(farey_file, 'r') as farey_csv:
		csvreader = csv.reader(farey_csv)
		for row in csvreader:
			farey_rows.append(row)
	with open(binary_file, 'r') as binary_csv:
		csvreader = csv.reader(binary_csv)
		for row in csvreader:
			binary_rows.append(row)
	
	data = {
		"n": list(range(3, 10_001)),
		"greedy": {
			"avgTerms": [],
			"minTerms": [],
			"maxTerms": [],
			"minDenom": [],
			"maxDenom": [],
		},
		"farey": {
			"avgTerms": [],
			"minTerms": [],
			"maxTerms": [],
			"minDenom": [],
			"maxDenom": [],
		},
		"binary": {
			"avgTerms": [],
			"minTerms": [],
			"maxTerms": [],
			"minDenom": [],
			"maxDenom": [],
		}
	}
	
	print("sorting data for:\ngreedy...")
	for row in greedy_rows[1:]:
		data["greedy"]["avgTerms"].append(int(row[1]))
		data["greedy"]["minTerms"].append(int(row[2]))
		data["greedy"]["maxTerms"].append(int(row[3]))
		data["greedy"]["minDenom"].append(int(row[4]))
		data["greedy"]["maxDenom"].append(int(row[5]))
	print("farey...")
	for row in farey_rows[1:]:
		data["farey"]["avgTerms"].append(int(row[1]))
		data["farey"]["minTerms"].append(int(row[2]))
		data["farey"]["maxTerms"].append(int(row[3]))
		data["farey"]["minDenom"].append(int(row[4]))
		data["farey"]["maxDenom"].append(int(row[5]))
	print("binary...")
	for row in binary_rows[1:]:
		data["binary"]["avgTerms"].append(int(row[1]))
		data["binary"]["minTerms"].append(int(row[2]))
		data["binary"]["maxTerms"].append(int(row[3]))
		data["binary"]["minDenom"].append(int(row[4]))
		data["binary"]["maxDenom"].append(int(row[5]))
	print("done, dumping .json file")
	with open(data_json_file, 'w') as file:
		json.dump(data, file)


def load_data_from_json():
	with open(data_json_file, 'r') as file:
		data = json.load(file)
	return data


consideration_dict={
	"avgTerms": "Average Number of Terms",
	"minTerms": "Minimum Number of Terms",
	"maxTerms": "Maximum Number of Terms",
	"minDenom": "Minimum of the largest Denominators",
	"maxDenom": "Maximum of the largest Denominators"
}


def plot_to_file(whattoconsider, start=1, end=-1, step=1, color_greedy="r", color_binary="g", color_farey="b", linestyle=".", logscale=False):
	print("plotting " + consideration_dict[whattoconsider] + "...", end="")
	x = data["n"][start:end:step]
	y1 = data["greedy"][whattoconsider][start:end:step]
	y2 = data["farey"][whattoconsider][start:end:step]
	y3 = data["binary"][whattoconsider][start:end:step]
	plt.figure(figsize=(15, 10), dpi=500)
	# plt.plot(x, y1, color_greedy + linestyle, label="greedy")
	plt.plot(x, y2, color_farey + linestyle, label="farey")
	plt.plot(x, y3, color_binary + linestyle, label="binary")
	if logscale:
		plt.yscale("log")
	plt.xlabel("n")
	plt.ylabel(whattoconsider + "(n)")
	plt.title(consideration_dict[whattoconsider])
	plt.legend(loc="upper left")
	plt.savefig('plots/' + whattoconsider + '.png')
	print(" done.")


# write_data_to_json()

data = load_data_from_json()

# norm greedy max numbers
gmaxD = data["greedy"]["maxDenom"]
norm = 1e250                        # max 1e+261
for i in range(0, len(gmaxD)-1):
	if gmaxD[i] > norm:
		gmaxD[i] = 'inf'


plot_to_file("maxDenom")


start = 0
end = -1
step = 1


what = "maxDenom"
x = data["n"][start:end:step]
y1 = data["greedy"][what][start:end:step]
y2 = data["farey"][what][start:end:step]
y3 = data["binary"][what][start:end:step]

plt.plot(x, y1, "r.", label="greedy")
plt.plot(x, y2, "b.", label="farey")
plt.plot(x, y3, "g.", label="binary")

plt.xlabel("n")
plt.ylabel(what + "(n)")
plt.title(consideration_dict[what])
plt.legend()
plt.yscale("log")
plt.show()
