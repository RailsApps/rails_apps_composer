after_everything do
	run "ln -s #{destination_root} ~/.pow/#{app_name}"
	
	gsub_file 'Gemfile', /gem 'sqlite3'\n/, ''
	gem 'pg', :group => :production
	gem 'sqlite3', :group => [:development, :test]
	run 'bundle install'

	gsub_file 'config/application.rb', /config.assets.enabled = true/ do
	<<-RUBY
config.assets.enabled = true
	config.assets.initialize_on_precompile=false
RUBY
	end

	%w{
    public/index.html
    app/assets/images/rails.png
  }.each { |file| remove_file file }

	run "heroku create"
	run "rake assets:precompile"
	git :add => "."
	git :commit => "-a -m 'initial commit for heroku'"
	run "git push origin master"
	run "git push heroku master"
	
	# SET ENVIRONMENT VARIABLES BEFORE SEEDING DB
	run "heroku config:add 'ROLES=[admin, user, VIP]'"
  run "heroku config:add ADMIN_NAME='First User' ADMIN_EMAIL='user@example.com' ADMIN_PASSWORD='please'"
  run "heroku config"

  run "heroku run rake db:migrate"
	run "heroku run rake db:seed"
end

__END__

name: deployment
description: "Set up POW and delpoy to Heroku"
author: David

requires: []
run_after: [init]
category: deployment