class Movie < ActiveRecord::Base
	def self.get_all_ratings
		return ['G','PG','PG-13','R']
	end

	def self.with_ratings(ratings)
		return self.where({rating: ratings})
	end
end
