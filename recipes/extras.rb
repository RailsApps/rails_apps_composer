# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb

## BAN SPIDERS
if config['ban_spiders']
  prefs[:ban_spiders] = true
end
if prefs[:ban_spiders]
  say_wizard "recipe banning spiders by modifying 'public/robots.txt'"
  after_bundler do
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
end

## JSRUNTIME
case RbConfig::CONFIG['host_os']
  when /linux/i
    prefs[:jsruntime] = yes_wizard? "Add 'therubyracer' JavaScript runtime (for Linux users without node.js)?" unless prefs.has_key? :jsruntime
    if prefs[:jsruntime]
      # was it already added for bootstrap-less?
      unless prefer :bootstrap, 'less'
        say_wizard "recipe adding 'therubyracer' JavaScript runtime gem"
        gem 'therubyracer', '>= 0.10.2', :group => :assets, :platform => :ruby
      end
    end
end

## RVMRC
if config['rvmrc']
  prefs[:rvmrc] = true
end
if prefs[:rvmrc]
  say_wizard "recipe creating project-specific rvm gemset and .rvmrc"
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
    raise "rvm failure: unable to use gemset #{app_name}"
  end
  run "rvm gemset list"
  copy_from_repo '.rvmrc'
  gsub_file '.rvmrc', /App_Name/, "#{app_name}"
end

## AFTER_EVERYTHING
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
  git :add => '.' if prefer :git, true
  git :commit => "-aqm 'rails_apps_composer: extras'" if prefer :git, true
end

## GITHUB
if config['github']
  gem 'hub', '>= 1.10.2', :require => nil, :group => [:development]
  after_everything do
    say_wizard "recipe creating GitHub repository"
    git_uri = `git config remote.origin.url`.strip
    unless git_uri.size == 0
      say_wizard "Repository already exists:"
      say_wizard "#{git_uri}"
    else
      run "hub create #{app_name}"
      unless prefer :railsapps, 'rails-prelaunch-signup'
        run "hub push -u origin master"
      else
        run "hub push -u origin #{prefs[:prelaunch_branch]}"
        run "hub push -u origin #{prefs[:main_branch]}" unless prefer :main_branch, 'none'
      end
    end
  end
end

__END__

name: extras
description: "Various extras."
author: RailsApps

requires: [gems]
run_after: [gems, init, prelaunch]
category: other

config:
  - ban_spiders:
      type: boolean
      prompt: Set a robots.txt file to ban spiders?
  - rvmrc:
      type: boolean
      prompt: Create a project-specific rvm gemset and .rvmrc?
  - github:
      type: boolean
      prompt: Create a GitHub repository?
