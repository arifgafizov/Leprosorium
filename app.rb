#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	# чтобы результаты выводились в виде хеша, а не масива
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	# добавили init_db т.к. метод before не исполняется при конфигурации
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content      TEXT
	)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]
  erb "You typed #{content}"
end