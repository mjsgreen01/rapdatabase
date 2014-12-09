#  s.visit "http://genius.com/2pac-got-my-mind-made-up-lyrics"
#  search_results = s.all(:css, ".featured_artists a")
# search_results.map{|e| e.text}
require "capybara"
require "capybarista"
require "JSON"

class SearchResultParser
	attr_accessor :session

	def initialize(session)
		@session = session
	end

	def scrollEntirePage(url)
		session.visit url
		begin	
			while session.first(:css, ".pagination") != nil
				5.times{
					session.execute_script("scrollTo(0,document.body.scrollHeight);")
					sleep 3
				}
				sleep 1
			end
		rescue
			puts "Something went wrong, moving on"
		end
		return self
	end

	def artistAlbumUrlArray(u)
		begin
			session.visit u

			if session.first(:css, ".album_link") != nil
				urls = session.all(:css, ".album_link")
				return urls.map {|u| u[:href]}
			else
				return nil
			end
		rescue
			puts "Something went wrong, moving on"
		end
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

	def artistUrlArray
		begin
			urls = session.all(:css, ".artist_link")
			return urls.map {|u| u[:href]}
		rescue
			puts "Something went wrong, moving on"
		end
	end

	def parseArray(u)
		begin

			return $parser.urlSearch(u)

			# theUrls = artistUrlArray
			# theUrls.map{|s| puts $parser.urlSearch(s)}
		rescue
			puts "Something went wrong, moving on"
		end
	end
end

class PageParser
	attr_accessor :session

	def initialize(session)
		@session = session
	end

	def findArtist
		begin
			artist = session.find(:css, ".text_artist a").text
			return artist
		rescue
			puts "Something went wrong, moving on"
		end
	end

	def findTitle
		begin
			title = session.find(:css, ".text_title").text
			return title
		rescue
			puts "Something went wrong, moving on"
		end
	end

	def findFeatured
		begin
			if session.first(:css, ".featured_artists a") != nil
				feat = session.all(:css, ".featured_artists a")
				return feat.map{|r| r.text}
			end
		rescue
			puts "Something went wrong, moving on"
		end
	end

	def findProducer
		begin
			if session.first(:css, ".producer_artists a") != nil
				producer = session.all(:css, ".producer_artists a")
				return producer.map{|r| r.text}
			end
		rescue
			puts "Something went wrong, moving on"
		end
	end

	def findAudioLink
		begin
			if session.first(:css, ".audio_link a") != nil
				link = session.find(:css, ".audio_link a")
				return link[:href]
			end
		rescue
			puts "Something went wrong, moving on"
		end
	end

	def urlSearch(url)
		begin
			session.visit url
			
			return {
				"artist" => findArtist,
				"title" =>  findTitle,
				"featured" => findFeatured,
				"producer" => findProducer,
				"audioLink" => findAudioLink
				}
		rescue
			puts "Something went wrong, moving on"
		end
	end
end

#to convert to JSON format===>  JSON.pretty_generate()

session = Capybara::Session.new :selenium
$parser = PageParser.new(session)

arrayParser = SearchResultParser.new(session)

# arrayParser.parseArray("http://genius.com/search?q=outkast")
artistUrls = arrayParser.scrollEntirePage("http://genius.com/artists").artistUrlArray
puts artistUrls
artistUrls_json = JSON.pretty_generate(artistUrls)
File.write("artistUrls.json", artistUrls_json)

albumUrls = artistUrls.map{|u| arrayParser.artistAlbumUrlArray(u)}.select{|i| i}
puts albumUrls
albumUrls_json = JSON.pretty_generate(albumUrls)
File.write("albumUrls.json", albumUrls_json)

songUrls = albumUrls.map{|u| u.map{|i| arrayParser.albumSongUrlArray(i)}}
puts songUrls
songUrls_json = JSON.pretty_generate(songUrls)
File.write("songUrls.json", songUrls_json)

songData = songUrls.map{|u| u.map{|i| i.map{|r| arrayParser.parseArray(r)}}}
puts songData
songData_json = JSON.pretty_generate(songData)
File.write("songData.json", songData_json)

# puts parser.urlSearch("http://genius.com/2pac-got-my-mind-made-up-lyrics")

