class Artist < ActiveRecord::Base

	has_many :song_involvements
	has_many :songs, through: :song_involvements


end
