if config['use_heroku']
  
  header = <<-YAML
<% if ENV['MONGOHQ_URL'] %>
<% mongohq = URI.parse(ENV['MONGOHQ_URL']) %>
mongohq:
  host: <%= mongohq.host %>
  port: <%= mongohq.port %>
  database: <%= mongohq.path.sub '/', '' %>
  username: <%= mongohq.user %>
  password: <%= mongohq.password %>
<% end %>
YAML

  after_everything do
    say_wizard 'Adding mongohq:free addon (you can always upgrade later)'  
    system 'heroku addons:add mongohq:free'
  end
else
  mongohq = URI.parse(config['uri'])
  
  header = <<-YAML
mongohq:
  host: #{mongohq.host}
  port: #{mongohq.port}
  database: #{mongohq.path.sub '/',''}
  username: #{mongohq.user}
  password: #{mongohq.password}
YAML
end

after_bundler do
  mongo_yml = "config/mongo#{'id' if recipe?('mongoid')}.yml"

  prepend_file mongo_yml, header
  inject_into_file mongo_yml, "  <<: *mongohq\n", :after => "production:\n  <<: *defaults\n"
end

__END__

name: MongoHQ
description: "Utilize MongoHQ as the production data host for your application."
author: mbleigh

requires_any: [mongo_mapper, mongoid]
run_after: [mongo_mapper, mongoid, heroku]
exclusive: mongodb_host
category: services
tags: [mongodb]

config:
  - use_heroku:
      type: boolean
      prompt: "Use the MongoHQ Heroku addon?"
      if_recipe: heroku
  - uri:
      type: string
      prompt: "Enter your MongoHQ URI:"
      unless: use_heroku
