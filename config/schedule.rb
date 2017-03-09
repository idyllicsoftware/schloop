#env :GEM_PATH, ENV['GEM_PATH']
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
every 2.days do # Use any day of the week or :weekend, :weekday
  rake "db:upload_db_dump", :environment => 'staging'
end
#use follwing config in crontab file
#0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57 * * * * cd /home/muktesh/workspace/schloop && RAILS_ENV=development /home/muktesh/.rvm/wrappers/ruby-2.3.1/bundle exec rake db:upload_db_dump --silent

# Learn more: http://github.com/javan/whenever
