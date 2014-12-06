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

		# while session.first(:css, ".pagination") != nil
		# 	session.execute_script("scrollTo(0,document.body.scrollHeight);")
		# 	sleep 1
		# end
		return self
	end

	def artistAlbumUrlArray(u)
			session.visit u

			if session.first(:css, ".album_link") != nil
				urls = session.all(:css, ".album_link")
				return urls.map {|u| u[:href]}
			else
				return nil
			end
	end

	def albumSongUrlArray(u)
		session.visit u

		urls = session.all(:css, ".song_name")
		return urls.map {|u| u[:href]}
	end

	def artistUrlArray

		urls = session.all(:css, ".artist_link")
		return urls.map {|u| u[:href]}
	end

	def parseArray(url)
		session.visit url

		theUrls = artistUrlArray
		theUrls.map{|u| puts $parser.urlSearch(u)}

	end
end

class PageParser
	attr_accessor :session

	def initialize(session)
		@session = session
	end

	def findArtist
		artist = session.find(:css, ".text_artist a").text
		return artist
	end

	def findTitle
		title = session.find(:css, ".text_title").text
		return title
	end

	def findFeatured
		feat = session.all(:css, ".featured_artists a")
		return feat.map{|r| r.text}
	end

	def findProducer
		if session.first(:css, ".producer_artists a") != nil
			producer = session.find(:css, ".producer_artists a").text
			return producer
		end
	end

	def findAudioLink
			link = session.find(:css, ".audio_link a")
			return link[:href]
	end

	def urlSearch(url)
		session.visit url
		
		return {
			"artist" => findArtist,
			"title" =>  findTitle,
			"featured" => findFeatured,
			"producer" => findProducer,
			"audioLink" => findAudioLink
			}
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

# puts parser.urlSearch("http://genius.com/2pac-got-my-mind-made-up-lyrics")

