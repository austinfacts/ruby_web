require 'sinatra'
# require 'sinatra/reloader' if development?
require './rsg'

get '/' do
  '<h1>Hello work!</h1>'
end

get '/:filename' do
  input = params[:filename]
  if input.match?(/[^\w\.\-]/)
    'That is not right'
  else
    rsg(params[:filename])
  end
end