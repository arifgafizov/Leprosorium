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
	# создает таблицу Posts если она не существует
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content      TEXT
	)'

	# создает таблицу Comments если она не существует
	@db.execute 'CREATE TABLE IF NOT EXISTS Comments (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    created_date DATE,
    content      TEXT,
    post_id	     INTEGER
	)'
end

get '/' do
	# выбираем список постов из БД
	@results = @db.execute 'SELECT * FROM Posts ORDER BY id DESC'

	erb :index			
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
  # сохранение данных в БД
  @db.execute 'INSERT INTO Posts (content, created_date) values (?, datetime())', [content]

  # перенаправление на главную страницу
  redirect to '/'
end

# вывод информации о  посте
get '/details/:post_id' do
	# Получаем переменную из url'а
	post_id = params[:post_id]

	# Запрос из БД одного поста по его id
	results = @db.execute 'SELECT * FROM Posts WHERE id = ?', [post_id]
	# присваеваем глобальной переменной row этот запрошенный пост
	@row = results[0]

	# выбираем комментарий для нашего поста
	@comments = @db.execute 'SELECT * FROM Comments WHERE id = ? ORDER BY id', [post_id]
	# возвращаем представление details.erb
	erb :details
end

# обработка пост запроса /details/...
post '/details/:post_id' do
	# Получаем переменную из url'а
	post_id = params[:post_id]

	# получаем переменную из пост запроса
  	content = params[:content]

  	# сохранение данных в БД
 	@db.execute 'INSERT INTO Сomments (content, created_date, post_id) values (?, datetime(), ?)', [content, post_id]

  	# перенаправление на страницу поста
	redirect to ('/details/' + post_id)
end