from matplotlib import pyplot as plt
import csv
import sys
import json

csv.field_size_limit(sys.maxsize)

greedy_file = "results_greedy.csv"
farey_file = "results_fastfarey.csv"
binary_file = "results_binary.csv"
data_json_file = "data.json"


def write_data_to_json():
	greedy_rows = []
	farey_rows = []
	binary_rows = []
	
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
	
	for row in greedy_rows[1:]:
		data["greedy"]["avgTerms"].append(row[1])
		data["greedy"]["minTerms"].append(row[2])
		data["greedy"]["maxTerms"].append(row[3])
		data["greedy"]["minDenom"].append(row[4])
		data["greedy"]["maxDenom"].append(row[5])
	for row in farey_rows[1:]:
		data["farey"]["avgTerms"].append(row[1])
		data["farey"]["minTerms"].append(row[2])
		data["farey"]["maxTerms"].append(row[3])
		data["farey"]["minDenom"].append(row[4])
		data["farey"]["maxDenom"].append(row[5])
	for row in binary_rows[1:]:
		data["binary"]["avgTerms"].append(row[1])
		data["binary"]["minTerms"].append(row[2])
		data["binary"]["maxTerms"].append(row[3])
		data["binary"]["minDenom"].append(row[4])
		data["binary"]["maxDenom"].append(row[5])
		
	with open(data_json_file, 'w') as file:
		json.dump(data, file)


def load_data_from_json():
	with open(data_json_file, 'r') as file:
		data = json.load(file)
	return data


def print_avg_terms(data, start, end, step, color_greedy="r", color_binary="g", color_farey="b", linestyle="-"):
	print("plotting Average Number of Terms...", end="")
	plt.figure(figsize=(15, 10), dpi=500)
	plt.plot(data["n"][start:end:step], data["greedy"]["avgTerms"][start:end:step], color_greedy + linestyle, data["binary"]["avgTerms"][start:end:step],
			 color_binary + linestyle, data["farey"]["avgTerms"][start:end:step], color_farey + linestyle)
	plt.yscale('linear')
	plt.title("Average Number of Terms")
	plt.savefig('plots/avgTerms.png')
	print(" done.")


def print_min_terms(data, start, end, step, color_greedy="r", color_binary="g", color_farey="b", linestyle="-"):
	print("plotting Minimum Number of Terms...", end="")
	plt.figure(figsize=(15, 10), dpi=500)
	plt.plot(data["n"][start:end:step], data["greedy"]["minTerms"][start:end:step], color_greedy+linestyle, data["binary"]["minTerms"][start:end:step],
	         color_binary+linestyle, data["farey"]["minTerms"][start:end:step], color_farey+linestyle)
	plt.yscale('linear')
	plt.title("Minimum Number of Terms")
	plt.savefig('plots/minTerms.png')
	print("done.")


def print_max_terms(data, start, end, step, color_greedy="r", color_binary="g", color_farey="b", linestyle="-"):
	print("plotting Maximum Number of Terms...", end="")
	plt.figure(figsize=(15, 10), dpi=500)
	plt.plot(data["n"][start:end:step], data["greedy"]["maxTerms"][start:end:step], color_greedy+linestyle, data["binary"]["maxTerms"][start:end:step],
	         color_binary+linestyle, data["farey"]["maxTerms"][start:end:step], color_farey+linestyle)
	plt.yscale('log')
	plt.title("Maximum Number of Terms")
	plt.savefig('plots/maxTerms.png')
	print("done.")


def print_min_denom(data, start, end, step, color_greedy="r", color_binary="g", color_farey="b", linestyle="-"):
	print("plotting Minimum of Largest Denominator...", end="")
	plt.figure(figsize=(15, 10), dpi=500)
	plt.plot(data["n"][start:end:step], data["greedy"]["minDenom"][start:end:step], color_greedy+linestyle, data["binary"]["minDenom"][start:end:step],
	         color_binary+linestyle, data["farey"]["minDenom"][start:end:step], color_farey+linestyle)
	plt.yscale('linear')
	plt.savefig('plots/minDenom.png')
	print("done.")


def print_max_denom(data, start, end, step, color_greedy="r", color_binary="g", color_farey="b", linestyle="-"):
	print("plotting Maximum of Largest Denominator...", end="")
	plt.figure(figsize=(15, 10), dpi=500)
	plt.plot(data["n"][start:end:step], data["greedy"]["maxDenom"][start:end:step], color_greedy+linestyle, data["binary"]["maxDenom"][start:end:step],
	         color_binary+linestyle, data["farey"]["maxDenom"][start:end:step], color_farey+linestyle)
	plt.title("maxDenom")
	plt.yscale("log")
	plt.savefig('plots/maxDenom.png')
	print("done.")


# write_data_to_json()

data = load_data_from_json()

start = 0
end = -1
step = 500
my_linestyle = "."
# print_avg_terms(data, start, end, step, linestyle=my_linestyle)
# print_min_terms(data, start, end, step, linestyle=my_linestyle)
# print_max_terms(data, start, end, step, linestyle=my_linestyle)
# print_min_denom(data, start, end, step, linestyle=my_linestyle)
# print_max_denom(data, start, end, step, linestyle=my_linestyle)

plt.figure(figsize=(15, 10), dpi=200)
# plt.axis(min(data["n"][start:end:step]), max(data["n"][start:end:step]), min(data["greedy"]["avgTerms"][start:end:step]), max(data["greedy"]["avgTerms"][start:end:step]))
plt.plot(data["n"][start:end:step], data["binary"]["minDenom"][start:end:step], "b-")
# plt.plot(data["greedy"]["maxDenom"][start:end:step], "r.")
# plt.plot(data["farey"]["maxDenom"][start:end:step], "g.")
# plt.ylim(1, 10^100)
# plt.yscale("linear")
# plt.yticks()
plt.show()
print(data["binary"]["minDenom"][start:end:1000])
