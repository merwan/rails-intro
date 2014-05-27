class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
    else
      @ratings = @all_ratings.map { |m| { m => 'on' } }
    end

    @movies = Movie.readonly
    @sort_column = params[:sort] || session[:sort]
    @movies = @movies.order(:title)  if @sort_column == 'title' 
    @movies = @movies.order(:release_date)if @sort_column == 'release_date'
    @movies = @movies.find_all_by_rating(@ratings.keys)

    session[:ratings] = @ratings
    session[:sort] = @sort_column

    if !params[:ratings] and !params[:sort] and !flash[:was_redirected]
      params[:ratings] = session[:ratings]
      params[:sort] = session[:sort]
      flash[:was_redirected] = true
      flash.keep
      redirect_to :action => :index, :sort => session[:sort], :ratings => session[:ratings]
    end
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

end
