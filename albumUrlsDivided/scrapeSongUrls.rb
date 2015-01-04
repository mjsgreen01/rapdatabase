require "capybara"
require "capybarista"
require "JSON"



class SearchResultParser
	attr_accessor :session

	def initialize(session)
		@session = session
	end

	def albumSongUrlArray(u)
		begin
			session.visit u

			urls = session.all(:css, ".song_name")
			return urls.map {|u| u[:href]}
		rescue
			puts "Something went wrong, moving on"
		end
	end

	def import_file(file_name)
		puts "importFile was called"
		data = File.read(file_name)
		puts "file was read"
		return JSON.parse(data)
	end

end



session = Capybara::Session.new :selenium
arrayParser = SearchResultParser.new(session)


[17,59,60,71,73,96,140,149].each do |j|
	begin
		puts "loop has begun"
		albumUrls = arrayParser.import_file("albumUrls#{j}.json")
		songsArray = albumUrls.map{|album|
			arrayParser.albumSongUrlArray(album)
		}.select{|i| i}
		songsUrls_json = JSON.pretty_generate(songsArray)
		File.write("songsUrls#{j}.json", songsUrls_json)
	rescue 
		puts "Something went wrong, moving on"
	end	
end
