if config['use_heroku']
  
  header = <<-YAML
<% if ENV['MONGOLAB_URI'] %>
<% mongolab = URI.parse(ENV['MONGOLAB_URI']) %>
mongolab:
  host: <%= mongolab.host %>
  port: <%= mongolab.port %>
  database: <%= mongolab.path.sub '/', '' %>
  username: <%= mongolab.user %>
  password: <%= mongolab.password %>
<% end %>
YAML

  after_everything do
    say_wizard 'Adding mongolab:starter addon (you can always upgrade later)'  
    system 'heroku addons:add mongolab:starter'
  end
else
  mongolab = URI.parse(config['uri'])
  
  header = <<-YAML
mongolab:
  host: #{mongolab.host}
  port: #{mongolab.port}
  database: #{mongolab.path.sub '/',''}
  username: #{mongolab.user}
  password: #{mongolab.password}
YAML
end

after_bundler do
  mongo_yml = "config/mongo#{'id' if recipe?('mongoid')}.yml"

  prepend_file mongo_yml, header
  inject_into_file mongo_yml, "  <<: *mongolab\n", :after => "production:\n  <<: *defaults\n"
end

__END__

name: mongolab (based on mongohq recipe)
description: "Utilize mongolab as the production data host for your application."
author: l4u (based on mongohq recipe by mbleigh)

requires_any: [mongo_mapper, mongoid]
run_after: [mongo_mapper, mongoid, heroku]
exclusive: mongodb_host
category: services
tags: [mongodb]

config:
  - use_heroku:
      type: boolean
      prompt: "Use the MongoLab Heroku addon?"
      if_recipe: heroku
  - uri:
      type: string
      prompt: "Enter your MongoLab URI:"
      unless: use_heroku
