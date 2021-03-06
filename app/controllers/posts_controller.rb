require 'csv'
require 'open-uri'
require 'redis'
require 'json'


class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  caches_page :index, :show
  
  
  def internet_connection?
    begin
      true if open("http://www.google.com/")
    rescue
      false
    end
  end

  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end


  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    #raise params[:post].inspect
    @post = Post.new(params[:post])
    if internet_connection?
      respond_to do |format|
        if @post.save
          format.html { redirect_to @post, notice: 'Post was successfully created.' }
          format.json { render json: @post, status: :created, location: @post }
        else
          format.html { render action: "new" }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    else
      CSV.open('articles.csv', 'w') do |csv|
        params[:post].each {|record| csv << record }
      end
    end  
    
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  def find_by_prefixes
    prefixes = []
    prefixes << params["term"]
    
    intersection_key = index_key_for(prefixes)
    
    index_keys       = prefixes.map {|prefix| index_key_for(prefix)}
    
    $redis.zinterstore(intersection_key, index_keys)
    $redis.expire(intersection_key, 7200)

    data_hash_keys  = $redis.zrevrange(intersection_key, 0, -1)
    
    matching_movies = $redis.hmget(data_key, *data_hash_keys)
    
    matching_movies.map {|movie| JSON.parse(movie, symbolize_names: true)}
    
    matching_movies_parsed_json =  matching_movies.map{|x| JSON.parse(x)}
    
    final_matching_movies = matching_movies_parsed_json.map{|x| x["name"]}
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: matching_movies_parsed_json }
    end
  end
  
 private
  
  def data_key
    "moviesearch:data"
  end

  def index_key
    "moviesearch:index"
  end
    
  def index_key_for(prefix)
    "#{index_key}:#{prefix}"
  end
  
end
