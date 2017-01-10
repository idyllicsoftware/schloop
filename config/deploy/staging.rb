branch = (ENV['branch'].nil? ? %x(git symbolic-ref --short -q HEAD).delete("\n") : ENV['branch'])
branch = "develop" if branch == ""

set :domain, 'staging.schloop.co'
set :branch, branch
set :user, 'ubuntu'
set :rails_env,'staging'