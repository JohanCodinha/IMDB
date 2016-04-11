require 'HTTParty'
require 'sinatra'
require 'sinatra/reloader'
#method to convert any string into utf-8 values
def to_utf (str)
  encoded_str = ''
  str.split('').each {|char| 
    encoded_char = char.encode('UTF-8')
    encoded_char.bytes.each {|byte|
      encoded_str << "%#{byte.to_s(16)}"
    }
  }
  return encoded_str
end

get '/' do
	erb :index
end

get '/search' do 
	result = HTTParty.get("http://www.omdbapi.com/?s=" + to_utf(params[:search]))

	#if the api returned anything
	if result['Error'] == nil
		@search_html_string = '<ul>'
		result['Search'].each {|movie|

			@search_html_string << "<li><a href='/display?id=#{movie['imdbID']}'>#{movie['Title']}</a></li>"

		}
		@search_html_string << '</ul>'

		erb :search
	else #if api didn't return result, print error message
		@search_html_string = "<p>#{result['Error']}</p>"
	end
end

get '/display' do 
	result = HTTParty.get("http://www.omdbapi.com/?i=" + params[:id] )
	
	#building HTML, the hard way
	@display_html_string = '<div>'
	result.each {|key, value|
		if key == 'Poster'
			@display_html_string << "<p><img src=#{value} alt=''></p>" if value != "N/A"
		else 
		@display_html_string << "<p>#{key} : #{value}</p>" if value != "N/A"
		end
	}
	@display_html_string << '</div>'

	erb :display
end