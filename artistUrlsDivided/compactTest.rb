require "JSON"

data = File.read("albumUrls1.json")
JSON.parse(data).compact.flatten

(1..10).each do |j|
	data = File.read("albumUrls#{j}.json")
	data2 = JSON.parse(data).compact.flatten
	data3 = JSON.pretty_generate(data2)
	File.write("albumUrls#{j}.json", data3)
end