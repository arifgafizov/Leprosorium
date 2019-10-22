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
	# инициализация БД
	init_db
end

configure do
	# добавили init_db т.к. метод before не исполняется при конфигурации
	init_db
	# создает таблицу если она не существует
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content      TEXT
	)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

# обработка гет запроса
get '/new' do
  erb :new
end

# обработка пост запроса
post '/new' do
	# получаем переменную из пост запроса
  content = params[:content]

  if content.length <= 0
  	@error = 'Type post text'
  	return erb :new
  end

  erb "You typed #{content}"
end