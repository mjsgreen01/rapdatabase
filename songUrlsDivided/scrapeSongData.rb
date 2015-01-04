#!/usr/bin/env ruby
require "capybara"
require "capybarista"
require "JSON"




class SearchResultParser
	attr_accessor :session

	def initialize(session)
		@session = session
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

	def import_file(file_name)
		puts "importFile was called"
		data = File.read(file_name)
		puts "file was read"
		return JSON.parse(data)
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



session = Capybara::Session.new :selenium
$parser = PageParser.new(session)

arrayParser = SearchResultParser.new(session)


(214..214).each do |j|
	begin
	puts "loop has begun"
	songUrls = arrayParser.import_file("songsUrls#{j}.json")
	songsData = songUrls.map{|song|
		arrayParser.parseArray(song)
	}.select{|i| i}
	songsData_json = JSON.pretty_generate(songsData)
	File.write("songData#{j}.json", songsData_json)



 #  	songData = a.map{|u| u.map{|i| arrayParser.parseArray(i)}}
	# puts songData
	# songData_json = JSON.pretty_generate(songData)
	# File.write("songData11_#{index}.json", songData_json)
	rescue
		puts "something went wrong with number #{j}, moving on"
	end

end