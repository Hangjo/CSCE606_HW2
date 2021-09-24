class Movie < ActiveRecord::Base
    def self.get_ratings
        ratings = self.select("distinct(rating)")
        return ratings.map(&:rating).sort
    end
    
    def self.with_ratings(ratings)
        movies = self.where(:rating => ratings)
        return movies
    end
end