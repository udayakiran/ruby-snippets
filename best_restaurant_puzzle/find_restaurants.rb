# This is the file which needs to be run to pass input and get the best priced restaurant.
# == To run
# - Go to the directory which has this script and type
#    ruby find_restaurants.rb [datafile] [item list seperated by space]
#   Ex - ruby find_restaurants.rb sample_data.csv burger pizza
  
# Creates a RestaurantFinder object with the passed arguments and calls methods on it 
# to display the required out put.

require 'restaurant_finder'

restaurant_finder = RestaurantFinder.new(ARGV)
restaurant_finder.find_best
restaurant_finder.inspect
