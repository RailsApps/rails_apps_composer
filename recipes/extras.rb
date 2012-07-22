# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb

if config['ban_spiders']
  say_wizard "Banning spiders by modifying 'public/robots.txt'"
  after_bundler do
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
end

if config['jsruntime']
  say_wizard "Adding 'therubyracer' JavaScript runtime gem"
  # maybe it was already added for bootstrap-less?
  unless recipes.include? 'bootstrap-less'
    gem 'therubyracer', :group => :assets, :platform => :ruby
  end
end

if config['rvmrc']
  # using the rvm Ruby API, see:
  # http://blog.thefrontiergroup.com.au/2010/12/a-brief-introduction-to-the-rvm-ruby-api/
  if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
    begin
      rvm_path     = File.dirname(File.dirname(ENV['MY_RUBY_HOME']))
      rvm_lib_path = File.join(rvm_path, 'lib')
      require 'rvm'
    rescue LoadError
      raise "RVM ruby lib is currently unavailable."
    end
  else
    raise "RVM ruby lib is currently unavailable."
  end
  say_wizard "creating RVM gemset '#{app_name}'"
  RVM.gemset_create app_name
  run "rvm rvmrc trust"
  say_wizard "switching to gemset '#{app_name}'"
  begin
    RVM.gemset_use! app_name
  rescue StandardError
    raise "Use rvm gem 1.11.3.5 or newer."
  end
  run "rvm gemset list"
  copy_from_repo '.rvmrc'
  gsub_file '.rvmrc', /App_Name/, "#{app_name}"
end

after_everything do
  say_wizard "recipe removing unnecessary files and whitespace"
  %w{
    public/index.html
    app/assets/images/rails.png
  }.each { |file| remove_file file }
  # remove commented lines and multiple blank lines from Gemfile
  # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
  gsub_file 'Gemfile', /#.*\n/, "\n"
  gsub_file 'Gemfile', /\n^\s*\n/, "\n"
  # remove commented lines and multiple blank lines from config/routes.rb
  gsub_file 'config/routes.rb', /  #.*\n/, "\n"
  gsub_file 'config/routes.rb', /\n^\s*\n/, "\n"
  # GIT
  git :add => '.' if recipes.include? 'git'
  git :commit => "-aqm 'rails_apps_composer: final commit'" if recipes.include? 'git'
end

__END__

name: extras
description: "Various extras."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - ban_spiders:
      type: boolean
      prompt: Set a robots.txt file to ban spiders?
  - jsruntime:
      type: boolean
      prompt: Add 'therubyracer' JavaScript runtime (for Linux users without node.js)?
  - rvmrc:
      type: boolean
      prompt: Create a project-specific rvm gemset and .rvmrc?