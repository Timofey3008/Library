require 'resque/scheduler'
require 'resque/server'
# uri = URI.parse("redis://localhost:6379/")
# Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

if Rails.env.development?
  Resque.redis = Redis.new(:host => 'localhost', :port => '6379')
else
  uri = URI.parse(ENV['REDISTOGO_URL'])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

  Resque.redis = REDIS
end

Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }