class MoviesController < ApplicationController

	def movie_params
		params.require(:movie).permit(:title, :rating, :description, :release_date)
	end

	def show
		id = params[:id] # retrieve movie ID from URI route
		@movie = Movie.find(id) # look up movie by unique ID
		# will render app/views/movies/show.<extension> by default
	end

	def index
		session_params_used = false

		if params.key?("sort_by")
			if params["sort_by"] == "title"
				@title_class = "hilite"
			elsif params["sort_by"] == "release_date"
				@release_date_class = "hilite"
			end
			temp = Movie.order(params["sort_by"])
			session["sort_by"] = params["sort_by"]
		elsif session.key?("sort_by")
			if session["sort_by"] == "title"
				@title_class = "hilite"
			elsif session["sort_by"] == "release_date"
				@release_date_class = "hilite"
			end
			temp = Movie.order(session["sort_by"])
			params.merge!("sort_by" => session["sort_by"])
			session_params_used = true
		else
			temp = Movie
		end

		@all_ratings = Movie.get_all_ratings
		if params.key?(:ratings)
			@selected = params[:ratings].keys
			session[:ratings] = params[:ratings]
		elsif session.key?(:ratings)
			@selected = session[:ratings].keys
			params.merge!(:ratings => session[:ratings])
			session_params_used = true
		else
			@selected = Movie.get_all_ratings
		end
		@movies = temp.with_ratings(@selected)
		if session_params_used
			flash.keep
			redirect_to movies_path(params)
		end
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

end
