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
		producer = session.find(:css, ".producer_artists a").text
		return producer
	end

	def urlSearch(url)
		session.visit url
		
		return {
			"artist" => findArtist,
			"title" =>  findTitle,
			"featured" => findFeatured,
			"producer" => findProducer,
			}
	end
end

#to convert to JSON format===>  JSON.pretty_generate()

session = Capybara::Session.new :selenium
$parser = PageParser.new(session)

arrayParser = SearchResultParser.new(session)

# arrayParser.parseArray("http://genius.com/search?q=odd")
arrayParser.parseArray("http://genius.com/search?q=pete+rock")

# puts parser.urlSearch("http://genius.com/2pac-got-my-mind-made-up-lyrics")

