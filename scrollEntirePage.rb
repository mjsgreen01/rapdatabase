require "capybara"
require "capybarista"
require "JSON"

class SearchResultParser
	attr_accessor :session

	def initialize(session)
		@session = session
	end

	def artistUrlArray
		begin
			urls = session.all(:css, ".artist_list:nth-last-child(-n+6) .artist_link")
			return urls.map {|u| u[:href]}
		rescue Exception => e
			Rails.logger.error(e)
			puts "Something went wrong, moving on"
		end
	end

	def scrollEntirePage(url)
		session.visit url
		begin	
			i=188
			begin
				begin
				i+=1
				5.times{
					session.execute_script("scrollTo(0,document.body.scrollHeight);")
					sleep 6
					
				}
				rescue Exception => e
					Rails.logger.error(e)
				end
				sleep 2
				begin
				artistUrlsDivided = artistUrlArray
				sleep 1
				artistUrls_json = JSON.pretty_generate(artistUrlsDivided)
				File.write("testArtistUrls#{i}.json", artistUrls_json)
				session.execute_script("$('.artist_list').css('display','none');
					$('.artist_list:nth-last-child(-n+2)').css('display','block');");
				rescue Exception => e
					Rails.logger.error(e)
					puts "Something went wrong with iteration number #{i}, moving on"
				end
				sleep 3
				
			end while session.first(:css, ".pagination") != nil
		rescue Exception => e
			Rails.logger.error(e)
			puts "Something went wrong with iteration number #{i}, moving on"
		end
		return self
	end


end


session = Capybara::Session.new :selenium
arrayParser = SearchResultParser.new(session)

artistUrls = arrayParser.scrollEntirePage("http://genius.com/artists?page=1113")
# File.write("testArtistUrls.json", artistUrls)
# puts artistUrls
# artistUrls_json = JSON.pretty_generate(artistUrls)
# File.write("testArtistUrls.json", artistUrls_json)