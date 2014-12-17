require "capybara"
require "capybarista"
require "JSON"



class SearchResultParser
	attr_accessor :session

	def initialize(session)
		@session = session
	end


	def artistAlbumUrlArray(u)
		begin
			session.visit u

			if session.first(:css, ".album_link") != nil
				if (session.all(:css, ".album_link").count>=3)
					urls = session.all(:css, ".album_link")
					return urls.map {|u| u[:href]}
				else
					return nil
				end
			else
				return nil
			end
		rescue
			puts "Something went wrong, moving on"
		end
	end

	def import_file(file_name)
		data = File.read(file_name)
		return JSON.parse(data)

	end

end


session = Capybara::Session.new :selenium
arrayParser = SearchResultParser.new(session)



(1..10).each do |j|
	begin
		artistUrls = SearchResultParser.import_file("#{Rails.root}/artistUrlsDivided/testArtistUrls#{j}.json")
		albumArray = artistUrls.map{|artist|
			SearchResultParser.artistAlbumUrlArray(artist)
		}
		albumUrls_json = JSON.pretty_generate(albumArray)
		File.write("albumUrls#{j}.json", albumUrls_json)
	rescue Exception => e
		Rails.logger.error(e)
	end	
end

