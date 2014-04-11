# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/init.rb

after_everything do
  say_wizard "recipe running after everything"
  case prefs[:email]
    when 'none'
      secrets_email = foreman_email = ''
    when 'smtp'
      secrets_email = foreman_email = ''
    when 'gmail'
      secrets_email = "  email_provider_username: <%= ENV[\"GMAIL_USERNAME\"] %>\n  email_provider_password: <%= ENV[\"GMAIL_PASSWORD\"] %>\n"
      foreman_email = "GMAIL_USERNAME=Your_Username\nGMAIL_PASSWORD=Your_Password\n"
    when 'sendgrid'
      secrets_email = "  email_provider_username: <%= ENV[\"SENDGRID_USERNAME\"] %>\n  email_provider_password: <%= ENV[\"SENDGRID_PASSWORD\"] %>\n"
      foreman_email = "SENDGRID_USERNAME=Your_Username\nSENDGRID_PASSWORD=Your_Password\n"
    when 'mandrill'
      secrets_email = "  email_provider_username: <%= ENV[\"MANDRILL_USERNAME\"] %>\n  email_provider_apikey: <%= ENV[\"MANDRILL_APIKEY\"] %>\n"
      foreman_email = "MANDRILL_USERNAME=Your_Username\nMANDRILL_APIKEY=Your_API_Key\n"
  end
  figaro_email  = foreman_email.gsub('=', ': ')
  secrets_devise = "  admin_name: <%= ENV[\"ADMIN_NAME\"] %>\n  admin_email: <%= ENV[\"ADMIN_EMAIL\"] %>\n  admin_password: <%= ENV[\"ADMIN_PASSWORD\"] %>\n"
  foreman_devise = "ADMIN_NAME=First User\nADMIN_EMAIL=user@example.com\nADMIN_PASSWORD=changeme\n"
  figaro_devise  = foreman_devise.gsub('=', ': ')
  secrets_omniauth = "  omniauth_provider_key: <%= ENV[\"OMNIAUTH_PROVIDER_KEY\"] %>\n  omniauth_provider_secret: <%= ENV[\"OMNIAUTH_PROVIDER_SECRET\"] %>\n"
  foreman_omniauth = "OMNIAUTH_PROVIDER_KEY: Your_Provider_Key\nOMNIAUTH_PROVIDER_SECRET: Your_Provider_Secret\n"
  figaro_omniauth  = foreman_omniauth.gsub('=', ': ')
  secrets_cancan = "  roles: <%= ENV[\"ROLES\"] %>\n" # unnecessary? CanCan will not be used with Rails 4.1?
  foreman_cancan = "ROLES=[admin, user, VIP]\n\n"
  figaro_cancan = foreman_cancan.gsub('=', ': ')
  ## EMAIL
  inject_into_file 'config/secrets.yml', secrets_email, :after => "development:\n" if rails_4_1?
  inject_into_file 'config/secrets.yml', secrets_email, :after => "production:\n" if rails_4_1?
  append_file '.env', foreman_email if prefer :local_env_file, 'foreman'
  append_file 'config/application.yml', figaro_email if prefer :local_env_file, 'figaro'
  ## DEVISE
  if prefer :authentication, 'devise'
    inject_into_file 'config/secrets.yml', secrets_devise, :after => "development:\n" if rails_4_1?
    inject_into_file 'config/secrets.yml', secrets_devise, :after => "production:\n" if rails_4_1?
    append_file '.env', foreman_devise if prefer :local_env_file, 'foreman'
    append_file 'config/application.yml', figaro_devise if prefer :local_env_file, 'figaro'
  end
  ## OMNIAUTH
  if prefer :authentication, 'omniauth'
    inject_into_file 'config/secrets.yml', secrets_omniauth, :after => "development:\n" if rails_4_1?
    inject_into_file 'config/secrets.yml', secrets_omniauth, :after => "production:\n" if rails_4_1?
    append_file '.env', foreman_omniauth if prefer :local_env_file, 'foreman'
    append_file 'config/application.yml', figaro_omniauth if prefer :local_env_file, 'figaro'
  end
  ## CANCAN
  if (prefer :authorization, 'cancan')
    inject_into_file 'config/secrets.yml', secrets_cancan, :after => "development:\n" if rails_4_1?
    inject_into_file 'config/secrets.yml', secrets_cancan, :after => "production:\n" if rails_4_1?
    append_file '.env', foreman_cancan if prefer :local_env_file, 'foreman'
    append_file 'config/application.yml', figaro_cancan if prefer :local_env_file, 'figaro'
  end
  ### SUBDOMAINS (FIGARO ONLY) ###
  copy_from_repo 'config/application.yml', :repo => 'https://raw.github.com/RailsApps/rails3-subdomains/master/' if prefer :starter_app, 'subdomains_app'
  ### EXAMPLE FILE FOR FOREMAN AND FIGARO ###
  if prefer :local_env_file, 'figaro'
    copy_file destination_root + '/config/application.yml', destination_root + '/config/application.example.yml'
  elsif prefer :local_env_file, 'foreman'
    copy_file destination_root + '/.env', destination_root + '/.env.example'
  end
  ### DATABASE SEED ###
  if (prefer :authentication, 'devise') and (rails_4_1?)
    copy_from_repo 'db/seeds.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise/master/'
    unless prefer :authorization, 'pundit'
      copy_from_repo 'app/services/create_admin_service.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise/master/'
    end
  end
  if prefer :authorization, 'pundit'
    copy_from_repo 'app/services/create_admin_service.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise-pundit/master/'
  end
  if prefer :local_env_file, 'figaro'
    append_file 'db/seeds.rb' do <<-FILE
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
FILE
    end
  elsif prefer :local_env_file, 'foreman'
    append_file 'db/seeds.rb' do <<-FILE
# Environment variables (ENV['...']) can be set in the file .env file.
FILE
    end
  end
  if (prefer :authorization, 'cancan')
    unless prefer :orm, 'mongoid'
      append_file 'db/seeds.rb' do <<-FILE
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end
FILE
      end
      ## Fix db seed for Rails 4.0
      gsub_file 'db/seeds.rb', /{ :name => role }, :without_protection => true/, 'role' if rails_4?
    else
      append_file 'db/seeds.rb' do <<-FILE
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.mongo_session['roles'].insert({ :name => role })
  puts 'role: ' << role
end
FILE
      end
    end
  end
  ## DEVISE-DEFAULT
  if (prefer :authentication, 'devise') and (not prefer :apps4, 'rails-devise') and (not rails_4_1?)
    append_file 'db/seeds.rb' do <<-FILE
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
FILE
    end
    # Mongoid doesn't have a 'find_or_create_by' method
    gsub_file 'db/seeds.rb', /find_or_create_by_email/, 'create!' if prefer :orm, 'mongoid'
  end
  ## DEVISE-CONFIRMABLE
  if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
    if rails_4_1?
      inject_into_file 'app/services/create_admin_service.rb', "        user.confirm!\n", :after => "user.password_confirmation = Rails.application.secrets.admin_password\n"
    else
      append_file 'db/seeds.rb', "user.confirm!\n"
    end
  end
  if (prefer :authorization, 'cancan') && !(prefer :authentication, 'omniauth')
    append_file 'db/seeds.rb', 'user.add_role :admin'
  end
  ## DEVISE-INVITABLE
  if prefer :devise_modules, 'invitable'
    if prefer :local_env_file, 'foreman'
      run 'foreman run bundle exec rake db:migrate'
    else
      run 'bundle exec rake db:migrate'
    end
    generate 'devise_invitable user'
  end
  ### APPLY DATABASE SEED ###
  unless prefer :orm, 'mongoid'
    unless prefer :database, 'default'
      ## ACTIVE_RECORD
      say_wizard "applying migrations and seeding the database"
      if prefer :local_env_file, 'foreman'
        run 'foreman run bundle exec rake db:migrate'
      else
        run 'bundle exec rake db:migrate'
      end
    end
  else
    ## MONGOID
    say_wizard "dropping database, creating indexes and seeding the database"
    if prefer :local_env_file, 'foreman'
      run 'foreman run bundle exec rake db:drop'
      run 'foreman run bundle exec rake db:mongoid:create_indexes'
    else
      run 'bundle exec rake db:drop'
      run 'bundle exec rake db:mongoid:create_indexes'
    end
  end
  unless prefs[:skip_seeds]
    unless prefer :railsapps, 'rails-recurly-subscription-saas'
      if prefer :local_env_file, 'foreman'
        run 'foreman run bundle exec rake db:seed'
      else
        run 'bundle exec rake db:seed'
      end
    end
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: set up database"' if prefer :git, true
  ### FRONTEND (must run after database migrations) ###
  # generate Devise views with appropriate styling
  if prefer :authentication, 'devise'
    case prefs[:frontend]
      when 'bootstrap3'
        generate 'layout:devise bootstrap3 -f'
      when 'foundation5'
        generate 'layout:devise foundation5 -f'
    end
  end
  # create navigation links using the rails_layout gem
  generate 'layout:navigation -f'
  # replace with specialized navigation partials
  copy_from_repo 'app/views/layouts/_navigation-subdomains_app.html.erb', :prefs => 'subdomains_app'
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: navigation links"' if prefer :git, true
end # after_everything

__END__

name: init
description: "Set up and initialize database."
author: RailsApps

requires: [setup, gems, models]
run_after: [setup, gems, models]
category: initialize
