# This is the unit test file with basic test cases for RestaurantFinder.
# == To run
# - Go to the directory which has this script and type
#    ruby restaurant_finder_test.rb
  
# RestaurantFinder#find_best method is tested for various cases. 
# This is the major and most testable method. So, only tests for this are covered.

require 'test/unit'
require '../restaurant_finder'

class RestaurantFinderTest < Test::Unit::TestCase

    def test_with_invalid_arguments
     assert_nil find_best([])
    end

    def test_with_file_that_does_not_exist
      assert_equal [], find_best(['iamnothere.csv', 'wine_spritzer'])
    end

    def test_empty_sample_input_file
      assert_equal [], find_best(['empty.csv', 'wine_spritzer'])
    end

    def test_empty_commas_sample_input_file
      assert_equal [], find_best(['empty_values.csv', 'wine_spritzer'])
    end

    def test_single_item_order
      assert_equal [[4, 2.5]], find_best(['sample.csv', 'wine_spritzer'])
    end

    def test_order_not_found
      assert_equal [], find_best(['sample.csv', 'iamnotinfile'])
    end

    def test_multiple_items_in_order
      assert_equal [[2, 11.5]], find_best(['sample.csv', 'burger', 'tofu_log'])
    end

    def test_multiple_restaurants_with_same_best_price
    	assert_equal [[1, 4.0], [2, 4.0]], find_best(['sample2.csv', 'burger'])
    end

    private
    def find_best(args)
      restaurant_finder = RestaurantFinder.new(args)
      restaurant_finder.find_best
    end
end
