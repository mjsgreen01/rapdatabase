#!/usr/bin/env ruby

require 'json'

# ARGV contains all of the command-line arguments
if ARGV.size < 3
  $stderr.puts "Usage: #{ $0 } [input.json] [count] [output_name]"
  exit
end

file_path   = ARGV[0]
count       = ARGV[1].to_i
output_name = ARGV[2]


song_urls = File.open(file_path) do |fin|
  JSON.parse(fin.read)
end


# Iterate over all of the artists.  Grab
# (((count))) artists at a time.
song_urls.each_slice(count).each_with_index do |subset, index|
  File.write(
    "#{output_name}_#{index}.json",
    JSON.pretty_generate(subset)
  )
end




