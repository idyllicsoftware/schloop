branch = (ENV['branch'].nil? ? %x(git symbolic-ref --short -q HEAD).delete("\n") : ENV['branch'])
branch = "develop" if branch == ""

set :domain, '52.23.232.204'
set :branch, branch
set :user, 'ubuntu'
set :rails_env,'staging'