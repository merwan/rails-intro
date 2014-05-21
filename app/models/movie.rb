class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def self.all_ratings
    Movie.select(:rating).distinct
  end
end
