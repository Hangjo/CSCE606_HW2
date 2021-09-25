class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.get_ratings
      @selectedRatings = @all_ratings
      
      @sortTerm = params[:sortTerm]
      
      if @sortTerm
        session[:sortTerm] = @sortTerm
      else
        @sortTerm = session[:sortTerm]
      end
      
      if params[:ratings]
        @selectedRatings = params[:ratings].keys
        session[:ratings] = @selectedRatings
      else
        if session[:ratings]
          @selectedRatings = session[:ratings]
        end
        
        @ratingsHash = Hash.new(0)
        
        @selectedRatings.each do |rating|
          @ratingsHash[rating] = 1
        end

        flash.keep
        redirect_to movies_path(:sortTerm => @sortTerm, :ratings => @ratingsHash)
      end
      
      @movies = Movie.with_ratings(@selectedRatings).order(@sortTerm)
      
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
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
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end