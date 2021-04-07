# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'pg'

def db_connect
  @connection = PG::connect(
    host: 'localhost',
    user: '',
    password: '',
    dbname: 'postgres')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def open_memo(name)
  @id = name
  @memo_data = { title: '', body: '' }
  File.open("#{name}.txt", 'r') do |file_data|
    file_data.each_line.with_index(0) do |line, i|
      if i < 1
        @memo_data[:title] = line
      else
        @memo_data[:body] += line
      end
    end
  end
end

def update_memo(name)
  File.open("#{name}.txt", 'w') do |file_data|
    file_data.puts params[:title]
    file_data.puts params[:body]
  end
end

get '/' do
  db_connect
  @connection.exec('SELECT * FROM memo_db ORDER BY id ASC') do |result|
    @memo_names_titles = []
    result.each do |memo_name_title|
      @memo_names_titles << memo_name_title
    end
  end
  erb :top
end

get '/new' do
  erb :new
end

get '/edit' do
  erb :edit
end

post '/' do
  title = params[:title]
  body = params[:body]
  db_connect
  @connection.exec('SELECT * FROM memo_db ORDER BY id DESC LIMIT 1') do |result|
    @memo_id = 1
    result.each do |count|
      count = count['id'].to_i + 1
      @memo_id = count.to_s
    end
    @connection.exec('INSERT INTO memo_db VALUES ($1, $2, $3);', [@memo_id, title, body])
  end
  redirect to("/#{@memo_id}")
end

get '/:id' do
  db_connect
  @id = params[:id]
  memo_id = @connection.exec('SELECT * FROM memo_db WHERE id=($1);', [@id])
  @memo_data = memo_id[0]
  erb :show
end

patch '/:id' do
  update_memo(params[:id])
  redirect to("/#{id}")
end

get '/:id/edit' do
  open_memo(params[:id])
  erb :edit
end

delete '/:id' do
  db_connect
  @connection.exec('DELETE FROM memo_db WHERE id=($1);', [params[:id]])
  redirect '/'
end
