require 'open-uri'

class Team < ActiveRecord::Base
  attr_accessible :name, :team_url

  has_many :players

  @teams = {
  :trippingolney => 'http://baseball.fantasysports.yahoo.com/b1/16633/1',
  :emiliobonerfacio => 'http://baseball.fantasysports.yahoo.com/b1/16633/2',
  :fistyuinthebumgarner => 'http://baseball.fantasysports.yahoo.com/b1/16633/3',
  :paisanoscalzones => 'http://baseball.fantasysports.yahoo.com/b1/16633/4',
  :gentianswardrobe => 'http://baseball.fantasysports.yahoo.com/b1/16633/5',
  :whowantskimbrel => 'http://baseball.fantasysports.yahoo.com/b1/16633/6',
  :thefuturegentian => 'http://baseball.fantasysports.yahoo.com/b1/16633/7',
  :highonethier => 'http://baseball.fantasysports.yahoo.com/b1/16633/8',
  :adamjonesisblack => 'http://baseball.fantasysports.yahoo.com/b1/16633/9',
  :lincecumdumpster => 'http://baseball.fantasysports.yahoo.com/b1/16633/10',
  :lyanbruanmvp => 'http://baseball.fantasysports.yahoo.com/b1/16633/11',
  :thetroutsniffers => 'http://baseball.fantasysports.yahoo.com/b1/16633/12',
}


#TODO This needs to be refactored to first check the team names. If the
#team name is different it needs to be updated. Next if there are new players
#they need to be added and the old players removed.

#looping through teams
  def self.scrape_yahoo_league
    @teams.each do |team, team_url|
      if Team.find_by_team_url(team_url) || Team.find_by_team_url(team_url) == nil
        @team = Team.new(:name => team, :team_url => team_url)
      else
        @team = Team.find_by_team_url(team_url)
        @team.update_attributes(:name => team )
      end
      normalize_data(team, team_url)
      combine_first_last_name(array_players)

      if Player.find_by_first_name_and_last_name(@player.first_name, @player.last_name) == nil
        @team.players << @player
        @team.save
      else
       logger.debug("Player #{@player.first_name} #{@player.last_name} is already on this team")
       next
      end
    end
  end

  def normalize_data(team, team_url)
    team_page = Nokogiri::HTML(open("#{team_url}"))
    players = team_page.css(".name").text
    players.gsub!(/([A-Z][^A-Z]+)/, '\1 ')
    players.gsub!(/([A-Z])/, '\1\2')
    players.gsub!(/(Shin-|O') /, '\1')
    array_players = players.split(' ')
    array_players.each_with_index do |name,index|
      if name == "CC"
        next
      elsif name == "Ty"
        next
      elsif name.length <= 2
        #TODO fix CC outlier
        array_players[index] = "#{name} " + "#{array_players[index+1]}"
        array_players.delete_at(index+1)
      end
    end

  end

  def combine_first_last_name(array_players)
    array_players.each_with_index do |player,index|
      @player = Player.new
      if index.even?
        @player.first_name = player
        @player.last_name = array_players[index+1]
      elsif player == "De"
        array_players[i] = "De Aza"
      else
        next
      end
    end
  end

end
