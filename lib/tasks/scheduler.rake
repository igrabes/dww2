desc "This task is called by the heroku scheduler addon"
task :scrape => :environment do
  puts "Updating the team rosters"
  Team.scrape_yahoo_league
  puts "Updating free agents"
  FreeAgent.scrape_free_agents
  puts "done."
end
