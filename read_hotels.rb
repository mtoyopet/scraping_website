require 'json'
require 'byebug'

class PrintJson
  def initialize(city_name, date)
    @city_name = city_name
    @date = date
  end

  def run
    filepath = "hotel_#{@city_name}_#{@date}.json"
    serialized_hotels = File.read(filepath)
    hotels = JSON.parse(serialized_hotels)

    hotels.each do |hotel|
      puts hotel["name"]
      puts hotel["reviews"]
      puts hotel["price"]
      puts hotel["address"]
      puts "   "
      puts "********************"
      puts "  "
    end
  end
end

PrintJson.new("Paris", "2018-12-20").run
