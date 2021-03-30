# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'

def open_memo
  @memo_data = { title: '', body: '' }
  File.open("#{@id}.txt", 'r') do |file_data|
    i = 0
    file_data.each_line do |line|
      if i < 1
        @memo_data[:title] = line
      else
        @memo_data[:body] += line
      end
      i += 1
    end
  end
end

def update_memo(name)
  @memo_data = { title: params[:title], body: params[:body] }
  File.open("#{name}.txt", 'w') do |file_data|
    file_data.puts params[:title]
    file_data.puts params[:body]
  end
end

get '/' do
  @file_names = Dir.glob('*.txt').sort_by do |f|
    File.mtime(f)
  end
  @file_name = @file_names.map do |file_name|
    File.basename(file_name, '.txt')
  end
  @titles = @file_names.map do |title|
    File.open(title, 'r', &:gets)
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
  file_name_id = SecureRandom.uuid
  update_memo(file_name_id)
  redirect to("/#{file_name_id}")
end

get '/:id' do
  @id = params[:id]
  open_memo
  erb :show
end

patch '/:id' do
  @id = params[:id]
  update_memo(@id)
  erb :show
  redirect to("/#{@id}")
end

get '/:id/edit' do
  @id = params[:id]
  open_memo
  erb :edit
end

delete '/:id' do
  @id = params[:id]
  File.delete("#{@id}.txt")
  redirect to('/')
end
