require 'open-uri'

class FreeAgent < ActiveRecord::Base
  attr_accessible :first_name, :last_name

def self.scrape_free_agents
  transaction_trends_page = Nokogiri::HTML(open("http://baseball.fantasysports.yahoo.com/b1/buzzindex?date=2012-07-22&pos=ALL&src=combined&sort=BI_A&sdir=1"))
    	hot_players = transaction_trends_page.css(".name").text
    	hot_players.gsub!(/([A-Z][^A-Z]+)/, '\1 ')
    	hot_players.gsub!(/([A-Z])/, '\1\2')
    	hot_players.gsub!(/(Shin-|O') /, '\1')
    	array_players = hot_players.split(' ')
    	array_players.each_with_index do |name,index|
    		if name == "CC"
        next
      elsif name == "Ty"
        next
        elsif name.length <= 2
    			array_players[index] = "#{name} " + "#{array_players[index+1]}"
    			array_players.delete_at(index+1)
    		end
    	end

			array_players.each_with_index do |player,index| 
			    		@free_agent = FreeAgent.new
			    		if index.even?
			    			@free_agent.first_name = player
			    			@free_agent.last_name = array_players[index+1]
			    		elsif player == "De"
			    				 array_players[i] = "De Aza"
			    		else
			    			next
			    		end

			    	@free_agent.save
				end 
			end
		end