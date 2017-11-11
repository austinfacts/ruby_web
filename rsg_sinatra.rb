require 'sinatra'
require 'sinatra/reloader' if development?
require './rsg'
require 'erb'

# get '/' do
#   @title = "Hello work!"
# end


get '/index' do
  filename = params['filename']
  unless filename.nil?
    if filename.match?(/[^\w\.\-]/)
      'That is not right'
    else
      @data = rsg(filename)
      erb :ui
    end
  else
    erb :ui
  end
end

get '/test' do
  "why you no work?"
end

# get '/:filename' do
#   input = params[:filename]
#   if input.match?(/[^\w\.\-]/)
#     'That is not right'
#   else
#     rsg(params[:filename])
#   end
# end