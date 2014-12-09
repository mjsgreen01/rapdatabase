class Song < ActiveRecord::Base

	has_many :song_involvements
	has_many :artists, through: :song_involvements

end
