require 'csv'
require 'sinatra'
require 'pry'
require './classes/db_mgr.rb'
#require 'sinatra-flash'
#!!!!!!!!!!!!!!!!! figure out how to use this

enable :sessions

db = Database_Manager.new 'todo_list_db'
#sql_helper.add_users_from_csv('user_info.csv')

get '/' do
  erb :login
end

post '/' do
  username = params['username']
  password = params['password']
  if db.validate_login?(username, password)
    session[:username] = username
    redirect '/lists'
  else
    redirect '/'
  end
end

get '/new' do
  erb :new
end

post '/new' do
  if db.validate_new_user?(params['new_username'], params['email']) && params['new_password'] == params['confirm_password']
    db.add_user(params['new_username'], params["new_password"], params["email"])
    redirect '/'
  end
  redirect '/new'
end


get '/lists' do
  erb :index, locals: { list_items: [] }
end

post '/lists' do
  #placeholder
end
