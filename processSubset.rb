#!/usr/bin/env ruby
require "capybara"
require "capybarista"
require "JSON"


if ARGV.size < 1
  $stderr.puts "Usage: #{ $0 } [input_subset.json]"
  exit 1
end

file_path = ARGV[0]

songs = File.open(file_path) do |fin|
  JSON.parse(fin.read)
end

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


songs.each_with_index do |a, index|
	begin
  	songData = a.map{|u| u.map{|i| arrayParser.parseArray(i)}}
	puts songData
	songData_json = JSON.pretty_generate(songData)
	File.write("songData11_#{index}.json", songData_json)
	rescue
		puts "something went wrong, moving on"
	end

end

