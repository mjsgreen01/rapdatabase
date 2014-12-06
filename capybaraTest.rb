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

		while session.first(:css, ".pagination") != nil
			session.execute_script("scrollTo(0,document.body.scrollHeight);")
			sleep 1
		end
		return self
	end



	def urlArray

		urls = session.all(:css, ".search_result a")
		return urlsArray = urls.map {|u| u[:href]}
	end

	def parseArray(url)
		session.visit url

		theUrls = urlArray
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
arrayParser.scrollEntirePage("http://genius.com/search?q=outkast")

# puts parser.urlSearch("http://genius.com/2pac-got-my-mind-made-up-lyrics")

