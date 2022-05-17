# Description: This file was created to recieve and save the data from an specific website. Also this program convert to a hash with a key-value standarts
# Author: Erick Augusto
# Last modification: 11/05/2022

# This part will require all the libs which will be used
require 'mechanize'

#require 'open-uri'

#require 'net/http'

agent = Mechanize.new # Starts the agent at this variable

def scrap_the_values(agent,url) # This function will process all values of which will be requested 
  page = agent.get(url)
  title          =  page.css("h2.newsie-titler").text.split("\r\n").find{|e| e.length > 0} # This variable will contain the title 
  location       =  page.css("b").text.partition(',').first                                # This variable will contain the location 
  date           =  page.css("b").text.partition(',').last                                 # This variable will contain the datetime  
  article        =  page.css("div.bodycopy").text.partition('\n\r').first                  # This variable will contain the article
  converted_date = Date.parse date 						           # This variable will parse the date and will be converted
  result = generate_hash(title, converted_date, location, article)
  return result # This function will return the result of the all processed variable and transform them to a hash
end


def generate_hash(title, date, location, article) # Here its the place where the string will be treated 
  content = {
       :title    => title.chomp('').strip, 
       :date     => date,
       :location => location.chomp('').strip, 
       :article  => article.chomp('')    
 	    }
  return content # will return all contents in a hash table
end


def save_to_disk(directory,agent) # Here this script will save the hash result into a file
  File.open(directory, 'a') do |file| # Oopen the file, if not exists, will create one
      scrap_the_values(agent, "https://agriculture.house.gov/news/documentsingle.aspx?DocumentID=2106").each { |k, v| file.write("#{k}: #{v}\n") } #starts the function which will scrap the website and rescue the data for a file
  end
end


response_data  = scrap_the_values(agent, "https://agriculture.house.gov/news/documentsingle.aspx?DocumentID=2106") # Activates the function which will start the request
puts response_data # Show the data which has been captured
save_to_disk("./scrap_from_website.txt",agent) # save to the disk at a txt file
