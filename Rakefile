lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'active_record'
require 'bundler/setup'
require 'padrino-core/cli/rake'

require 'rake/clean'

require 'mechanize'
require 'json'
require 'pry-byebug'

require 'fisk8aks/parser'
require 'fisk8aks/updater'

PadrinoTasks.use(:database)
PadrinoTasks.use(:activerecord)
PadrinoTasks.init

db_filename = "db/fisk8aks_development.db"
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: db_filename)

parser = Fisk8aks::Parser.new
updater = Fisk8aks::Updater.new

################
task :pry do
  binding.pry
  puts "pry"
end

################
namespace :skaters do
  task :parse do
    binding.pry
    p skaters = parser.parse_skaters
  end

  task :update do
    skaters = parser.parse_skaters

    $stderr.puts "updating database"
    skaters.each do |hash|
      #$stderr.print "..#{hash['isu_number']}"
      updater.update_skater(hash)
    end
    $stderr.puts "done."
  end
end
################
namespace :competitions do
  parser = Fisk8aks::Parser.new

  task :parse do
    #binding.pry
    p competitions = parser.parse_competitions(1)
  end

  task :update do
    max_page = ENV['MAX_PAGE'] || 1
    competitions = parser.parse_competitions(max_page.to_i)
    $stderr.puts "updating database..."
    updater = Fisk8aks::Updater.new
    competitions.each do |hash|
      updater.update_competition(hash)
    end
    $stderr.puts "done."
  end
end
################
namespace :score do
  task :parse do
    sid = 16125
    p score = parser.parse_score(sid)
  end

  task :update do
    #binding.pry
    sid = ENV['SID'] || 16125
    fname = "#{sid}_score.json"

    if !File.exists? fname
      score = parser.parse_score(sid)
      File.open(fname, "w"){|f| f.write(score.to_json)}
    end
    score = JSON.load(File.open(fname))
    
    updater.update_score(score)
  end
end

################
namespace :scores do
  task :update do
    competition = Competition.first
    
  end
end
