# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'
require 'pry'

Artist.destroy_all
Song.destroy_all
SongInvolvement.destroy_all


def import_file(file_name)
	data = File.read(file_name)
	songs = JSON.parse(data)
	songs.flatten!

	songs.each do |song_hash|
		next unless song_hash
		main_artist = Artist.find_or_create_by(name: song_hash["artist"])
		song = Song.create(title: song_hash["title"], song_link: song_hash["audioLink"])
		song.song_involvements.create(artist: main_artist, primary: true)

		if song_hash["featured"]
			song_hash["featured"].each do |feat_artist_name|
				feat_artist = Artist.find_or_create_by(name: feat_artist_name)
				song.song_involvements.create(artist: feat_artist, featured: true)
			end
		end
		if song_hash["producer"]
			song_hash["producer"].each do |producer_artist_name|
				producer_artist = Artist.find_or_create_by(name: producer_artist_name)
				song.song_involvements.create(artist: producer_artist, producer: true)
			end
		end
	end

	
end

(1..214).each do |i|
	begin
		import_file("#{Rails.root}/db/data/songData#{i}.json")
	rescue Exception => e
		Rails.logger.error(e)
		puts "error at file #{i}"
	end	
end