require 'optparse'
require 'csv'

class RestaurantFinder

  attr_reader :arguments

  def initialize(arguments)
    @arguments = arguments
    @restaurants = []
    @best_restaurants = []
    @order = []
  end

  # This method parses the initializer arguments. Verifies them and shows messages if
  # arguments are not valid
  # a) populates the restautants array from csv file.
  # b) searches for an order to return an array with restaurant id as first element
  # and minimum price of the orderas the second element.
  # c) In cases where multiple restaurents have the same minimum price for an order,
  # this returns an array where each member is an array described in (b)
  
  def find_best

    if parsed_options? && arguments_valid?
      populate_restaurants_from_file
      unless @restaurants.empty?
        initialize_order_from_arguments
        find_best_restaurants_and_price
      end
      @best_restaurants
    else
      output_usage
    end

  end

  # Prints the restaurnt id and the best price of the order sepetated by comma
  # Ex - if @best_restaurants is [[1, 2.0], [3, 2.0]]
  # Out Put - "1, 2.0"
  #           "3, 2.0"

  def inspect
    if @best_restaurants.empty?
      p nil
    else
      @best_restaurants.each { |restaurant| p restaurant.join(", ")}
    end
  end

  private
  
  def initialize_order_from_arguments
    @order = @arguments[1..@arguments.size-1]
  end

  # This method populated the @best_restaurants instance variable with the
  # an arry of best priced restaurants for the given @order.
  # If none of the restaurants can match the whole order then it's value is an
  # empty arry
  # Ex - If restaurant 2 and 3 both match the order for a minimun price 3.00
  # Output - [[2, 3.0], [3,3.0]]
  #Ex - If only restaurant 2  matches the order for a minimum price 3.00
  # Output - [[2, 3.0]]

  def find_best_restaurants_and_price
    resturants_with_best_prices = @restaurants.collect do |rest_hash|
      restaurant_id = rest_hash.keys.first
      menu = rest_hash.values.first
      min_price = best_price_within_restaurant(menu)
      [restaurant_id, min_price] if min_price
    end.compact

    return if resturants_with_best_prices.size == 0
    best_price_across_restuarants = resturants_with_best_prices.map(&:last).min

    @best_restaurants = resturants_with_best_prices.select do |member|
      member.last == best_price_across_restuarants
    end
  end

  # Finds the minimum possible price for an order within a restarant menu.
  # Returns nil if order can't be matched from menu.
  # Example - Parameter menu = {:prices=>[5.0, 6.0],
  #                             :items=>["item_one", ["item_one", "item_two", "item_three"]]
  # @order - ["item_one", "item_two"]
  # Out put - 6.0
  def best_price_within_restaurant(menu)
    return nil unless all_items_available?(menu)

    (1..@order.length).collect do |i|
      menu[:items].combination(i).collect do |combination|
        order_price, item_indexes = nil
        next unless (@order - combination.flatten).empty?
        item_indexes = combination.collect {|item| menu[:items].index item}
        next if item_indexes.empty?

        order_price = menu[:prices].find_all do |item_price|
          item_indexes.include? menu[:prices].index(item_price)
        end.inject(0){ |sum, price| sum + price }

        order_price
      end.compact
    end.flatten.compact.min
  end

  # Returns true if all the items in the order are available in menu
  def all_items_available?(menu)
    (@order - menu[:items].flatten.uniq).empty?
  end

  # Reads the input csv file and populates the @resturants attr_accessor.
  # Silently ignores the malformatted rows.
  # ==Sample input csv -
  # Data File data.csv
  # 5, 4.00, extreme_fajita
  # 5, 5.00, fancy_european_water
  # 6, 5.00, fancy_european_water
  # 6, 4.00, extreme_fajita, jalapeno_poppers
  # ==Sample @restaurants value -
  # [ {5 => {:prices => [4.0, 8.0],
  #         :items => ["extreme_fajita", "fancy_european_water"]}
  #     },
  #  {6 => {:prices => [5.0, 6.0],
  #         :items => ["fancy_european_water", ["extreme_fajita", "jalapeno_poppers"]]}
  #   }
  # ]
  
  def populate_restaurants_from_file
    @file_name = @arguments.first
    csv = ::CSV::parse(File.open(@file_name, 'r') {|f| f.read })

    csv.each do |rec|
      rec.compact!  #Eliminate all nils caused by empty fields
      rec.map(&:strip!).compact! #Eliminate all leading/trailing white spaces and empty space chars in fields
      next if rec.length < 3 #Ignore if the particular row has not enough of information.

      rest_id = rec[0] && rec[0].to_i
      price = rec[1] && rec[1].to_f
      items = rec.slice(2..rec.length-1).flatten

      if @restaurants.map(&:keys).flatten.include? rest_id
        existing = @restaurants.select {|i| i.keys.first == rest_id}.first
        existing[rest_id].merge({
            :prices => existing[rest_id][:prices] << price,
            :items => existing[rest_id][:items] << (items.single? ? items.first : items)
          })
      else
        @restaurants << ({rest_id => {:prices => [price], :items => [items.single? ? items.first : items]}})
      end

    end
  rescue Errno::ENOENT => e
    p "No file '#{@file_name}' found in the current directory."
  rescue => e
    @restaurants = []
  end

  # Parsing the arguments.
  def parsed_options?
    opts = OptionParser.new
    opts.parse!(@arguments) rescue return false

    true
  end

  # True if 2 of the required arguments were provided
  def arguments_valid?
    @arguments.length >= 2
  end

  def output_usage
    p "Invalid arguments!"
    p "Please run the script as shown below."
    p "ruby restaurant_finder.rb sample.csv item1 item2"
  end

end

# Just open the Array class and added a method for convinicence.
# Kept it in the same file just to avoid one more extra file.
class Array
  #true for array of size 1.
  def single?
    size == 1
  end
end
