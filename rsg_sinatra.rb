require 'sinatra'
require 'sinatra/reloader' if development?
require './rsg'


get '/:filename' do
  input = params[:filename]
  if input.match?(/[^\w\.\-]/)
    "That is not right"
  else
    rsg(params[:filename])
  end
end