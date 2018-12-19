require 'json'
require 'byebug'

filepath = 'hotel_info_2018-12-19.json'

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
