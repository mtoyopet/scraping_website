require 'open-uri'
require 'nokogiri'
require 'byebug'
require 'json'
require 'date'

class ScrapeBooking
  def initialize(city_name, checkin_month, checkin_date, checkin_year, checkout_month, checkout_date, checkout_year)
    @city_name = city_name
    @checkin_month = checkin_month
    @checkin_date = checkin_date
    @checkin_year = checkin_year
    @checkout_month = checkout_month
    @checkout_date = checkout_date
    @checkout_year = checkout_year
  end

  def scrape
    url = "https://www.booking.com/searchresults.en-gb.html?label=gen173nr-1FCAEoggI46AdIM1gEaHWIAQGYATG4AQfIAQzYAQHoAQH4AQKIAgGoAgM&lang=en-gb&sid=ebbfeee32a0e7f1c7e296a2841362b90&sb=1&src=index&src_elem=sb&error_url=https%3A%2F%2Fwww.booking.com%2Findex.en-gb.html%3Flabel%3Dgen173nr-1FCAEoggI46AdIM1gEaHWIAQGYATG4AQfIAQzYAQHoAQH4AQKIAgGoAgM%3Bsid%3Debbfeee32a0e7f1c7e296a2841362b90%3Bsb_price_type%3Dtotal%3Bsrpvid%3D5cb70b649ec50208%26%3B&ss=#{@city_name}&is_ski_area=0&ssne=Tokyo&ssne_untouched=Tokyo&dest_id=-246227&dest_type=city&checkin_monthday=#{@checkin_date}&checkin_month=#{@checkin_month}&checkin_year=#{@checkin_year}&checkout_monthday=#{@checkout_date}&checkout_month=#{@checkout_month}&checkout_year=#{@checkout_year}&no_rooms=1&group_adults=2&group_children=0&b_h4u_keep_filters=&from_sf=1"

    html = open(url, {
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36"
    }).read

    parsed_content = Nokogiri::HTML html
    contents = parsed_content.css(".sr_item")
    hotels_array = Array.new

    contents.each do |content|
      hotel = {
        name: content.css(".sr-hotel__title").css(".sr-hotel__name").text.strip,
        reviews: content.css(".bui-review-score__badge").inner_text.strip,
        price: content.css(".roomPrice").css(".price").inner_text.strip,
        address: content.css(".jq_tooltip").inner_text.strip.split("\n").first
      }
      hotels_array << hotel
    end

    selected_hotels = hotels_array.reject { |hotel| hotel[:reviews].empty? || hotel[:price].empty? }

    selected_hotels.each do |hotel|
      puts hotel[:name]
      puts hotel[:reviews]
      puts hotel[:price]
      puts hotel[:address]
      puts ""
    end

    output_filename = "hotel_#{@city_name.downcase}_#{Date.today.strftime}.json"

    File.open(output_filename, 'wb') do |file|
      file.write(JSON.generate(hotels_array))
    end

    puts "Hotels info have successfuly been saved to a json file...."

  end
end

ScrapeBooking.new("Orlando", "4", "14", "2019", "4", "19", "2019").scrape
