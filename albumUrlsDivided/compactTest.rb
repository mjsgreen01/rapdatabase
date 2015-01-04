require "JSON"

[17,59,60,71,73,96,140,149].each do |j|
	begin
	data = File.read("songsUrls#{j}.json")
	data2 = JSON.parse(data).compact.flatten
	data3 = JSON.pretty_generate(data2)
	File.write("songsUrls#{j}.json", data3)
	rescue
		puts "something went wrong with file #{j}"
	end
end