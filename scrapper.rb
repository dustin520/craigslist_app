# scrapper.rb
require 'nokogiri'
require 'open-uri'
require 'awesome_print'


# def filter_links(rows, regex)
#   # takes in rows and returns uses
#   # regex to only return links 
#   # that have "pup", "puppy", or "dog"
#   # keywords
#   search = regex.match(/ (\A\spuppy\s\z) | (\A\spup\s\z) | (\A\sdog\s\z) /)
#   # dogs = results.select {|row| row.css(".hdrlnk").text.match(/(puppy|pup|dog)/i)}

#   answer = doc.css(".row .hdrlnk").each do |data|
#   if data == search
#     puts data
#     puts "*" * 60
#   end
# end

def get_todays_rows(doc, date_str, regex)
  #  1.) open chrome console to look in inside p.row to see
  #  if there is some internal date related content
  #  2.) figure out the class that you'll need to select the
  #   date from a row
  rows = doc.css(".row")
  results = []

  rows.each do |row|
    check_date = row.css(".date").text
    pet_search = row.css(".hdrlnk").text
    if  check_date == date_str && pet_search.match(regex)
      results.push(row)
    end
  end
  # p results
  return results
end


def get_page_results
  url = "http://sfbay.craigslist.org/sfc/pet/"
  doc = Nokogiri::HTML(open(url))
end

def search(date_str)
  doc = get_page_results()
  regex = /\b(Puppy|puppy|Pup|pup|Dog|dog)\b/
  the_results = get_todays_rows(doc, date_str, regex)

  # ap the_results

  the_results.each do |display|
    title = display.css(".hdrlnk").text
    url = display.css('a[href][1]') 
    obj = { Description: title, link: url}
    puts obj
    puts "*" * 60
  end

end

# want to learn more about 
# Time in ruby??
#   http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/Date.html#strftime-method
today = Time.now.strftime("%b %d")
search(today)

