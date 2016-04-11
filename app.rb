require 'HTTParty'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb :index
end

get '/search' do 
	result = HTTParty.get("http://www.omdbapi.com/?s=" + params[:search])

	if result['Error'] == nil
		@search_html_string = '<ul>'

		result['Search'].each {|movie|

			@search_html_string << "<li><a href='/display?id=#{movie['imdbID']}'>#{movie['Title']}</a></li>"

		}
		@search_html_string << '</ul>'
		erb :search
	else 
		@search_html_string = "<p>#{result['Error']}</p>"
	end
end

get '/display' do 
	result = HTTParty.get("http://www.omdbapi.com/?i=" + params[:id] )
	
	@display_html_string = '<div>'
	result.each {|key, value|
		if key == 'Poster'
			@display_html_string << "<p><img src=#{value} alt=''></p>" if value != "N/A"
		else 
		@display_html_string << "<p>#{key} : #{value}</p>" if value != "N/A"
		end
	}
	@display_html_string << '</div>'

	# @display_html_string = '<div>'
	# @display_html_string << "<p>Title : #{result['Title']}</p>" if result["Title"] != "N/A"
	# @display_html_string << "<p>Director : #{result['Director']}</p>" if result["Director"] != "N/A"
	# @display_html_string << "<p><img src=#{result['Poster']} alt=''></p>" if result["Poster"] != "N/A"
	# @display_html_string << "<p>Plot : #{result['Plot']}</p>" if result["Plot"] != "N/A"
	# @display_html_string << '</div>'
	erb :display
end