prepend_file "config/initializers/redis.rb", <<-RUBY
uri = URI.parse(ENV['REDISTOGO_URL'])

RUBY

inject_into_file "config/initializers/redis.rb", :after => "Redis.new" do
  "(:host => uri.host, :port => uri.port, :password => uri.password)"
end

env("REDISTOGO_URL", "redis://localhost:6379")

after_bundler do
  if config['use_heroku']
    say_wizard "Adding redistogo:nano Heroku addon, you can always upgrade later."
    run "heroku addons:add redistogo:nano"
  else
    env("REDISTOGO_URL", config['url'], 'production') if config['url']
  end
end
__END__

name: RedisToGo
description: "Use RedisToGo hosting for this app's Redis."
author: mbleigh

requires: [redis, env_yaml]
run_after: [redis, env_yaml]
category: services

config:
  - use_heroku:
      type: boolean
      prompt: "Use the RedisToGo Heroku addon?"
      if_recipe: heroku
  - url:
      type: string
      prompt: "Enter your RedisToGo URL:"
      unless: use_heroku

