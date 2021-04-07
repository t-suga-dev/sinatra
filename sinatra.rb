# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'

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
  file_names = Dir.glob('*.txt').sort_by do |f|
    File.mtime(f)
  end
  memo_names = file_names.map do |memo_name|
    File.basename(memo_name, '.txt')
  end
  titles = file_names.map do |title|
    File.open(title, 'r', &:gets)
  end
  @memo_names_titles = memo_names.zip(titles)
  erb :top
end

get '/new' do
  erb :new
end

get '/edit' do
  erb :edit
end

post '/' do
  file_name_id = SecureRandom.uuid
  update_memo(file_name_id)
  redirect to("/#{file_name_id}")
end

get '/:id' do
  open_memo(params[:id])
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
  File.delete("#{params[:id]}.txt")
  redirect to('/')
end
