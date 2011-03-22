

say_wizard "Generating config/env.yaml..."

append_file "config/application.rb", <<-RUBY

require 'env_yaml'
RUBY

create_file "lib/env_yaml.rb", <<-RUBY
require 'yaml'
begin
  env_yaml = YAML.load_file(File.dirname(__FILE__) + '/../config/env.yml')
  if env_hash = env_yaml[ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development']
    puts env_hash.inspect
    env_hash.each_pair do |k,v|
      ENV[k] = v.to_s
    end
  end
rescue StandardError => e
end

RUBY

create_file "config/env.yml", <<-YAML
defaults:
  ENV_YAML: true

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
YAML

def env(k,v,rack_env='development')
  inject_into_file "config/env.yml", :after => "#{rack_env}:\n  <<: *defaults" do
    <<-YAML
#{k}: #{v.inspect}    
YAML
  end
end

__END__

name: EnvYAML
description: "Allows you to set environment variables in a YAML file at config/env.yaml"
author: mbleigh

category: other
tags: [utilities, configuration]
