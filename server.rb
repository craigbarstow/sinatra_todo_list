require 'sinatra'
require 'pry'
require 'csv'

enable :sessions

get '/' do
  erb :login
end

post '/' do
  user_info = {}
  CSV.foreach('user_info.csv', headers: true) do |row|
    user_info[row[1]] = {:name => row[0], :password => row[2], :list_file => row[3]}
  end
  if user_info[params['username']][:password] == params['password']
    session[:name] = user_info[params['username']][:name]
    session[:list_file] = user_info[params['username']][:list_file]
    redirect '/groceries'
  else
    redirect '/'
  end
end

get '/new' do
  erb :new
end

post '/new' do
  taken_usernames = []
  CSV.foreach('user_info.csv', headers: true) do |row|
    taken_usernames.push([row[0]])
  end
  unless taken_usernames.include?([params['new_username']])
    new_filename = "#{params[:new_username]}.txt"
    new_file = File.open("./lists/#{new_filename}", "w")
    new_file.close
    CSV.open('user_info.csv', "a") do |file|
      file.puts([params['new_name'], params['new_username'], params['new_password'], new_filename])
    end
    redirect '/'
  end
  redirect '/new'
end


get '/groceries' do
  list_items = File.readlines("lists/#{session[:list_file]}")
  erb :index, locals: { list_items: list_items, name: session[:name] }
end

post '/groceries' do
  File.open("lists/#{session[:list_file]}", "a") do |file|
    #add exception handling here
    file.puts(params['new_item'])
  end
  redirect '/groceries'
end
