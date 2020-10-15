require 'resque'
require 'resque/tasks'
require 'resque/scheduler/tasks'

#task "resque:setup" => :environment
task "resque:preload" => :environment

namespace :resque do
  task :preload do
    require 'resque'
    #require 'resque_scheduler'
    require 'resque/scheduler'

    Resque.redis = 'localhost:6379'

    Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
  end
end