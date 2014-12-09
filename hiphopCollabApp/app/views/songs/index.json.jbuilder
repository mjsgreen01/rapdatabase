json.array!(@songs) do |song|
  json.extract! song, :id, :primary_rapper, :featured_rapper, :producer, :title, :song_link
  json.url song_url(song, format: :json)
end
