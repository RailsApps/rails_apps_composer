if config['redis']
  gem 'redis'

  after_bundler do
    say_wizard "Generating Redis initializer..."

    create_file "config/initializers/redis.rb" do <<-RUBY
  REDIS = Redis.new
    RUBY
    end
  end
else
  recipes.delete('redis')
end
__END__

name: Redis
description: "Add Redis as a persistence engine to your application."
author: mbleigh

exclusive: key_value
category: persistence
tags: [key_value, cache, session_store]