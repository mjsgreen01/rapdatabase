class Artist < ActiveRecord::Base

	has_many :song_involvements
	has_many :songs, through: :song_involvements

	def collaborators
		collabsArray = self.songs.map{|i| i.artists}.flatten
		collabsArray.map{|i| i.name}
	end



	def structureNodesJson
		artists_array = []
		Artist.all.each{|i| n = i.name
			artists_array.push n
		}

		nodes = artists_array.map{|name|  {"name" => name, "group" => 1 }  }
		links = []
		artists_array.each{|i|
			collabs = i.collaborators
			collabsNames = collabs.map{|c| c.name}
			collabsNames.each{|n|
				links.push({"source"=>artists_array.index(i), "target"=>artists_array.index(n), "value"=>2})
			}
		}
	end




end
