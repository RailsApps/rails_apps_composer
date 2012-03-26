# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/datamapper.rb
RAILS_VERSION='~> 3.1.0'
DM_VERSION='~> 1.2.0'

if config['datamapper']
  abort "DataMapper #{DM_VERSION} is only compatible with Rails #{RAILS_VERSION}" unless ::Rails::VERSION::MAJOR == 3 and ::Rails::VERSION::MINOR < 2
else
  recipes.delete('datamapper')
end

if config['datamapper']
  say_wizard "REMINDER: When creating a Rails app using DataMapper,"
  say_wizard "you must add the '-O' flag to 'rails new'"
  gem 'dm-rails', DM_VERSION
  gem "dm-#{config['database']}-adapter", DM_VERSION
  gem 'dm-migrations', DM_VERSION
  gem 'dm-types', DM_VERSION
  gem 'dm-constraints', DM_VERSION
  gem 'dm-transactions', DM_VERSION
  gem 'dm-aggregates', DM_VERSION
  gem 'dm-timestamps', DM_VERSION
  gem 'dm-observer', DM_VERSION
  gem 'dm-validations', DM_VERSION if config['validations'] == 'dm-validations'
  gem 'dm-devise', '>= 2.0.1' if recipes.include? 'devise'

  inject_into_file 'config/application.rb', "require 'dm-rails/railtie'\n", :after => "require 'action_controller/railtie'\n"
  prepend_file 'app/controllers/application_controller.rb', "require 'dm-rails/middleware/identity_map'\n"
  inject_into_class 'app/controllers/application_controller.rb', 'ApplicationController', "  use Rails::DataMapper::Middleware::IdentityMap\n"
  create_file 'config/database.yml' do <<-YAML
defaults: &defaults
  adapter: #{config['database']}

production: 
  <<: *defaults

development: 
  <<: *defaults

test:
  <<: *defaults
YAML
  end
  case config['database']
  when "mysql", "postgres", "oracle", "sqlserver"
    sane_app_name = app_name.gsub(/[^a-zA-Z0-9_]/, '_')
    dbname = ask_wizard "Database name \033[33m[#{sane_app_name}]\033[0m"
    dbname = sane_app_name if dbname.empty?
    dbhost = ask_wizard "Database host \033[33m[localhost]\033[0m"
    dbhost = 'localhost' if dbhost.empty?
    dbuser = ask_wizard "Database username \033[33m[root]\033[0m"
    dbuser = 'root' if dbuser.empty?
    dbpass = ask_wizard "Database password \033[33m[]\033[0m"
    inject_into_file 'config/database.yml', "  password: '#{dbpass}'\n", :after => "  adapter: #{config['database']}\n"
    inject_into_file 'config/database.yml', "  username: #{dbuser}\n", :after => "  adapter: #{config['database']}\n"
    inject_into_file 'config/database.yml', "  host: #{dbhost}\n", :after => "  adapter: #{config['database']}\n"
    inject_into_file 'config/database.yml', "  database: #{dbname}\n", :before => "\ndevelopment:"
    inject_into_file 'config/database.yml', "  database: #{dbname}_development\n", :before => "\ntest:"
    append_file 'config/database.yml', "  database: #{dbname}_test"
  when "sqlite"
    inject_into_file 'config/database.yml', "  database: db/production.db\n", :before => "\ndevelopment:"
    inject_into_file 'config/database.yml', "  database: db/development.db\n", :before => "\ntest:"
    append_file 'config/database.yml', "  database: db/test.db\n"
  end
end

if config['datamapper']
  after_bundler do
    say_wizard "DataMapper recipe running 'after bundler'"
    if recipes.include? 'devise'
      generate 'data_mapper:devise_install' 
      gsub_file 'config/initializers/devise.rb', /# config.data_mapper_validation_lib = nil/, "config.data_mapper_validation_lib = '#{config['validations']}'"
    end
    rake "db:create:all" if config['auto_create']
  end
end

__END__

name: DataMapper
description: "Use DataMapper to connect to a data store (requires Rails ~> 3.1.0)."
author: Peter Fern

category: persistence
exclusive: orm
tags: [orm, datamapper, sql]

args: ["-O"]

config:
  - datamapper:
      type: boolean
      prompt: Would you like to use DataMapper to connect to a data store (requires Rails ~> 3.1.0)?
  - database:
      type: multiple_choice
      prompt: "Which backend are you using?"
      choices:
        - ["SQLite", sqlite]
        - ["MySQL", mysql]
        - ["PostgreSQL", postgres]
        - ["Oracle", oracle]
        - ["MSSQL", sqlserver]
  - validations:
      type: multiple_choice
      prompt: "Which validation method do you prefer?"
      choices:
        - ["DataMapper Validations", dm-validations]
        - ["ActiveModel Validations", active_model]
  - auto_create:
      type: boolean
      prompt: "Automatically create database with default configuration?"
