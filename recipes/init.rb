# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/init.rb

stage_three do
  say_wizard "recipe stage three"
  copy_from_repo 'config/secrets.yml' if Rails::VERSION::MAJOR == 5 && Rails::VERSION::MINOR >= 2
  copy_from_repo 'config/secrets.yml' if Rails::VERSION::MAJOR >= 6
  if (!prefs[:secrets].nil?)
    prefs[:secrets].each do |secret|
      env_var = "  #{secret}: <%= ENV[\"#{secret.upcase}\"] %>"
      inject_into_file 'config/secrets.yml', "\n" + env_var, :after => "development:"
      ### 'inject_into_file' doesn't let us inject the same text twice unless we append the extra space, why?
      inject_into_file 'config/secrets.yml', "\n" + env_var + " ", :after => "\n" + "production:"
    end
  end
  case prefs[:email]
    when 'none'
      secrets_email = foreman_email = ''
    when 'smtp'
      secrets_email = foreman_email = ''
    when 'gmail'
      secrets_email = "  email_provider_username: <%= ENV[\"GMAIL_USERNAME\"] %>\n  email_provider_password: <%= ENV[\"GMAIL_PASSWORD\"] %>"
      foreman_email = "GMAIL_USERNAME=Your_Username\nGMAIL_PASSWORD=Your_Password\nDOMAIN_NAME=example.com\n"
    when 'sendgrid'
      secrets_email = "  email_provider_username: <%= ENV[\"SENDGRID_USERNAME\"] %>\n  email_provider_password: <%= ENV[\"SENDGRID_PASSWORD\"] %>"
      foreman_email = "SENDGRID_USERNAME=Your_Username\nSENDGRID_PASSWORD=Your_Password\nDOMAIN_NAME=example.com\n"
    when 'mandrill'
      secrets_email = "  email_provider_username: <%= ENV[\"MANDRILL_USERNAME\"] %>\n  email_provider_apikey: <%= ENV[\"MANDRILL_APIKEY\"] %>"
      foreman_email = "MANDRILL_USERNAME=Your_Username\nMANDRILL_APIKEY=Your_API_Key\nDOMAIN_NAME=example.com\n"
  end
  figaro_email  = foreman_email.gsub('=', ': ')
  secrets_d_devise = "  admin_name: First User\n  admin_email: user@example.com\n  admin_password: changeme"
  secrets_p_devise = "  admin_name: <%= ENV[\"ADMIN_NAME\"] %>\n  admin_email: <%= ENV[\"ADMIN_EMAIL\"] %>\n  admin_password: <%= ENV[\"ADMIN_PASSWORD\"] %>"
  foreman_devise = "ADMIN_NAME=First User\nADMIN_EMAIL=user@example.com\nADMIN_PASSWORD=changeme\n"
  figaro_devise  = foreman_devise.gsub('=', ': ')
  secrets_omniauth = "  omniauth_provider_key: <%= ENV[\"OMNIAUTH_PROVIDER_KEY\"] %>\n  omniauth_provider_secret: <%= ENV[\"OMNIAUTH_PROVIDER_SECRET\"] %>"
  foreman_omniauth = "OMNIAUTH_PROVIDER_KEY=Your_Provider_Key\nOMNIAUTH_PROVIDER_SECRET=Your_Provider_Secret\n"
  figaro_omniauth  = foreman_omniauth.gsub('=', ': ')
  ## EMAIL
  inject_into_file 'config/secrets.yml', "\n" + "  domain_name: example.com", :after => "development:"
  inject_into_file 'config/secrets.yml', "\n" + "  domain_name: <%= ENV[\"DOMAIN_NAME\"] %>", :after => "\n" + "production:"
  inject_into_file 'config/secrets.yml', "\n" + secrets_email, :after => "development:"
  unless prefer :email, 'none'
    ### 'inject_into_file' doesn't let us inject the same text twice unless we append the extra space, why?
    inject_into_file 'config/secrets.yml', "\n" + secrets_email + " ", :after => "\n" + "production:"
    append_file '.env', foreman_email if prefer :local_env_file, 'foreman'
    append_file 'config/application.yml', figaro_email if prefer :local_env_file, 'figaro'
  end
  ## DEVISE
  if prefer :authentication, 'devise'
    inject_into_file 'config/secrets.yml', "\n" + '  domain_name: example.com' + " ", :after => "test:"
    inject_into_file 'config/secrets.yml', "\n" + secrets_d_devise, :after => "development:"
    inject_into_file 'config/secrets.yml', "\n" + secrets_p_devise, :after => "\n" + "production:"
    append_file '.env', foreman_devise if prefer :local_env_file, 'foreman'
    append_file 'config/application.yml', figaro_devise if prefer :local_env_file, 'figaro'
    gsub_file 'config/initializers/devise.rb', /'please-change-me-at-config-initializers-devise@example.com'/, "'no-reply@' + Rails.application.secrets.domain_name"
  end
  ## OMNIAUTH
  if prefer :authentication, 'omniauth'
    inject_into_file 'config/secrets.yml', "\n" + secrets_omniauth, :after => "development:"
    ### 'inject_into_file' doesn't let us inject the same text twice unless we append the extra space, why?
    inject_into_file 'config/secrets.yml', "\n" + secrets_omniauth + " ", :after => "\n" + "production:"
    append_file '.env', foreman_omniauth if prefer :local_env_file, 'foreman'
    append_file 'config/application.yml', figaro_omniauth if prefer :local_env_file, 'figaro'
  end
  ## rails-stripe-coupons
  if prefer :apps4, 'rails-stripe-coupons'
    gsub_file 'config/secrets.yml', /<%= ENV\["PRODUCT_TITLE"\] %>/, 'What is Ruby on Rails'
    gsub_file 'config/secrets.yml', /<%= ENV\["PRODUCT_PRICE"\] %>/, '995'
  end
  ### EXAMPLE FILE FOR FOREMAN AND FIGARO ###
  if prefer :local_env_file, 'figaro'
    copy_file destination_root + '/config/application.yml', destination_root + '/config/application.example.yml'
  elsif prefer :local_env_file, 'foreman'
    copy_file destination_root + '/.env', destination_root + '/.env.example'
  end
  ### DATABASE SEED ###
  if prefer :authentication, 'devise'
    copy_from_repo 'db/seeds.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise/master/'
    if prefer :authorization, 'roles'
      copy_from_repo 'app/services/create_admin_service.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise-roles/master/'
    elsif prefer :authorization, 'pundit'
      copy_from_repo 'app/services/create_admin_service.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise-pundit/master/'
    else
      copy_from_repo 'app/services/create_admin_service.rb', :repo => 'https://raw.github.com/RailsApps/rails-devise/master/'
    end
  end
  if prefer :apps4, 'rails-stripe-coupons'
    copy_from_repo 'app/services/create_couponcodes_service.rb', :repo => 'https://raw.github.com/RailsApps/rails-stripe-coupons/master/'
    append_file 'db/seeds.rb' do <<-FILE
CreateCouponcodesService.new.call
puts 'CREATED PROMOTIONAL CODES'
FILE
    end
  end
  if prefer :apps4, 'rails-stripe-membership-saas'
    append_file 'db/seeds.rb' do <<-FILE
CreatePlanService.new.call
puts 'CREATED PLANS'
FILE
    end
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
  ## DEVISE-CONFIRMABLE
  if (prefer :devise_modules, 'confirmable') || (prefer :devise_modules, 'invitable')
    inject_into_file 'app/services/create_admin_service.rb', "        user.confirm\n", :after => "user.password_confirmation = Rails.application.secrets.admin_password\n"
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
  if File.exists?('db/migrate')
    ## ACTIVE_RECORD
    say_wizard "applying migrations and seeding the database"
    if prefer :local_env_file, 'foreman'
      run 'foreman run bundle exec rake db:migrate'
    else
      run 'bundle exec rake db:migrate'
    end
  end
  unless prefs[:skip_seeds]
    if prefer :local_env_file, 'foreman'
      run 'foreman run bundle exec rake db:seed'
    else
      run 'bundle exec rake db:seed'
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
      when 'bootstrap4'
        generate 'layout:devise bootstrap3 -f'
      when 'foundation5'
        generate 'layout:devise foundation5 -f'
    end
  end
  # create navigation links using the rails_layout gem
  if prefs[:frontend] == 'bootstrap4'
    generate 'layout:navigation bootstrap4 -f'
  else
    generate 'layout:navigation -f'
  end
  if prefer :apps4, 'rails-stripe-coupons'
    inject_into_file 'app/views/layouts/_nav_links_for_auth.html.erb', ", data: { no_turbolink: true }", :after => "new_user_registration_path"
    inject_into_file 'app/views/layouts/_nav_links_for_auth.html.erb', "\n    <li><%= link_to 'Coupons', coupons_path %></li>", :after => "users_path %></li>"
  end
  if prefer :apps4, 'rails-stripe-membership-saas'
    inject_into_file 'app/views/layouts/_nav_links_for_auth.html.erb', ", data: { no_turbolink: true }", :after => "new_user_registration_path"
    copy_from_repo 'app/views/devise/registrations/edit.html.erb', :repo => 'https://raw.github.com/RailsApps/rails-stripe-membership-saas/master/'
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: navigation links"' if prefer :git, true
end

__END__

name: init
description: "Set up and initialize database."
author: RailsApps

requires: [setup, gems, devise, omniauth]
run_after: [setup, gems, pages]
category: initialize
