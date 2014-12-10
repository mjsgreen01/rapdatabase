	def structureNodesJson(passedArtists)
		artists_array = []
		allArtists = passedArtists
		allArtists.each{|i| n = i.name
			artists_array.push n
		}

		nodes = artists_array.map{|name|  {"name" => name, "group" => 1 }  }

		links = []
		allArtists.each{|i|
			collabs = i.collaborators
			collabs.each{|n|
				if artists_array.include?(n)
					links.push({"source"=>artists_array.index(i.name), "target"=>artists_array.index(n), "value"=>2})
				end
			}
		}

		jsonData = {"nodes"=>nodes, "links"=>links}
	end



#use offset function to specify artists to pass into the function e.g. artists 100-200



#jsonData = structureNodesJson
#prettyjson = JSON.pretty_generate(jsonData)
#File.write("jsonData.json", prettyjson)