gem 'redis'

say_wizard "Generating Redis initializer..."

initializer "redis.rb", <<-RUBY
REDIS = Redis.new
RUBY

__END__

name: Redis
description: "Add Redis as a persistence engine to your application."
author: mbleigh

exclusive: key_value
category: persistence
tags: [key_value, cache, session_store]
