class MoviesController < ApplicationController

  before_filter :setup

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.where(rating: @selected_ratings)
    params[:order_direction] ||= "ASC"
    @movies = @movies.order "#{params[:order_column]} #{params[:order_direction]}" if params[:order_column]

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def setup
    @rating_options = ['G','PG','PG-13','R']
    if params[:ratings]
      @selected_ratings = session[:movie_ratings] = params[:ratings].keys
    else
      @selected_ratings = session[:movie_ratings] || ['G','PG','PG-13','R']
    end

    if params[:order_column]
      @header_css = "hilite"
    else
      @header_css = ""
    end
  end

end
