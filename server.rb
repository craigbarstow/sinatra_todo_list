require 'csv'
require 'sinatra'
require 'pry'
require './classes/db_mgr.rb'

enable :sessions

db = DatabaseManager.new 'todo_list_db'

get '/' do
  erb :login
end

post '/' do
  username = params['username']
  password = params['password']
  user_id = db.validate_login?(username, password)
  unless user_id == -1
    session[:user_id] = user_id
    redirect '/home'
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

get '/logout' do
  session.clear
  redirect '/'
end

get '/home' do
  if db.validate_user?(session[:user_id])
    lists_data = db.get_list_titles(session[:user_id])
    title_id_array = []
    lists_data.each do |row|
      title_id_array.push({title: row['list_title'], id: row['id']})
    end
    reset_current_list
    erb :list_index, locals: { title_id_array: title_id_array }
  else
    redirect '/'
  end
end

post '/home' do
  list_title = params["new_title"]
  if list_title == nil || list_title == ""
    list_title = "Untitled List"
  end
  db.add_list(list_title, DateTime.now.to_s, session[:user_id]) #FIXME, start here, should be add list
  redirect '/home'
end

post '/home.delete' do
  db.delete_list(params[:list_id], session[:user_id])
end

get '/home/list' do
  if db.validate_user?(session[:user_id])
    if session[:list_id] == nil
      list_id = params['id']
      session[:list_id] = list_id
    end
    list_title = db.get_list_title_from_id(session[:list_id])
    items_array = []
    list_items = db.get_list_items(session[:list_id], session[:user_id])
    list_items.each do |row|
      items_array.push({id: row['id'], item: row['item']})
    end
    erb :list, locals: {title: list_title, item_hashes: items_array}
  else
    redirect '/'
  end
end

post '/home/list' do
  new_item = params['new_item']
  db.add_list_item(new_item, session[:list_id], session[:user_id])
  redirect '/home/list'
end

post '/home/list.delete' do
  db.delete_list_item(params[:item_id], session[:user_id])
end

delete '/items' do

end


def reset_current_list
  session[:list_id] = nil
end
