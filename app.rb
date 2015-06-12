# app.rb
#подключение гемов
require 'sinatra'
require 'sinatra/activerecord'
require './environments'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
enable :sessions

class Post < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

# отображени всего списка posts
get "/" do
  @posts = Post.order("created_at DESC")
  erb :"posts/index"
end

# create new post
get "/posts/create" do
  @post = Post.new
  erb :"posts/create"
end

#действия при успешном/неуспешном создание post
post "/posts" do
  @post = Post.new(params[:post])
  if @post.save
    redirect "posts/#{@post.id}", :notice => 'Congrats! Love the new post. (This message will disapear in 4 seconds.)'
  else
    redirect "posts/create", :error => 'Title and body went wrong. Try again. (This message will disapear in 4 seconds.)'
  end
end

# show post
get "/posts/:id" do
  @post = Post.find(params[:id])
  erb :"posts/show"
end

# edit post
get "/posts/:id/edit" do
  @post = Post.find(params[:id])
  erb :"posts/edit"
end

# обновление post
put "/posts/:id" do
  @post = Post.find(params[:id])
  @post.update(params[:post])
  redirect "/posts/#{@post.id}"
end

# del post
get "/posts/:id/delete" do
  @post = Post.find(params[:id])
  @post.destroy
  redirect '/' 
end