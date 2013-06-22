# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/extras.rb

## RVMRC
rvmrc_detected = false
if File.exist?('.rvmrc')
  rvmrc_file = File.read('.rvmrc')
  rvmrc_detected = rvmrc_file.include? app_name
end
if File.exist?('.ruby-gemset')
  rvmrc_file = File.read('.ruby-gemset')
  rvmrc_detected = rvmrc_file.include? app_name
end
unless rvmrc_detected || prefs[:rvmrc]
  prefs[:rvmrc] = yes_wizard? "Use or create a project-specific rvm gemset?"
end
if prefs[:rvmrc]
  if which("rvm")
    say_wizard "recipe creating project-specific rvm gemset and .rvmrc"
    # using the rvm Ruby API, see:
    # http://blog.thefrontiergroup.com.au/2010/12/a-brief-introduction-to-the-rvm-ruby-api/
    # https://rvm.io/integration/passenger
    if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
      begin
        gems_path = ENV['MY_RUBY_HOME'].split(/@/)[0].sub(/rubies/,'gems')
        ENV['GEM_PATH'] = "#{gems_path}:#{gems_path}@global"
        require 'rvm'
        RVM.use_from_path! File.dirname(File.dirname(__FILE__))
      rescue LoadError
        raise "RVM gem is currently unavailable."
      end
    end
    say_wizard "creating RVM gemset '#{app_name}'"
    RVM.gemset_create app_name
    say_wizard "switching to gemset '#{app_name}'"
    # RVM.gemset_use! requires rvm version 1.11.3.5 or newer
    rvm_spec =
      if Gem::Specification.respond_to?(:find_by_name)
        Gem::Specification.find_by_name("rvm")
      else
        Gem.source_index.find_name("rvm").last
      end
      unless rvm_spec.version > Gem::Version.create('1.11.3.4')
        say_wizard "rvm gem version: #{rvm_spec.version}"
        raise "Please update rvm gem to 1.11.3.5 or newer"
      end
    begin
      RVM.gemset_use! app_name
    rescue => e
      say_wizard "rvm failure: unable to use gemset #{app_name}, reason: #{e}"
      raise
    end
    run "rvm gemset list"
    if File.exist?('.ruby-version')
      say_wizard ".ruby-version file already exists"
    else
      create_file '.ruby-version', "#{RUBY_VERSION}\n"
    end
    if File.exist?('.ruby-gemset')
      say_wizard ".ruby-gemset file already exists"
    else
      create_file '.ruby-gemset', "#{app_name}\n"
    end
  else
    say_wizard "WARNING! RVM does not appear to be available."
  end
end

## QUIET ASSETS
if config['quiet_assets']
  prefs[:quiet_assets] = true
end
if prefs[:quiet_assets]
  say_wizard "recipe setting quiet_assets for reduced asset pipeline logging"
  add_gem 'quiet_assets', :group => :development
end

## LOCAL_ENV.YML FILE
if config['local_env_file']
  prefs[:local_env_file] = true
end
if prefs[:local_env_file]
  say_wizard "recipe creating application.yml file for environment variables"
  add_gem 'figaro'
end

## BETTER ERRORS
if config['better_errors']
  prefs[:better_errors] = true
end
if prefs[:better_errors]
  say_wizard "recipe adding better_errors gem"
  add_gem 'better_errors', :group => :development
  add_gem 'binding_of_caller', :group => :development, :platforms => [:mri_19, :rbx]
end

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
        add_gem 'libv8'
        add_gem 'therubyracer', :group => :assets, :platform => :ruby, :require => 'v8'
      end
    end
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
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: extras"' if prefer :git, true
end

## GITHUB
if config['github']
  prefs[:github] = true
end
if prefs[:github]
  add_gem 'hub', :require => nil, :group => [:development]
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
  - github:
      type: boolean
      prompt: Create a GitHub repository?
  - local_env_file:
      type: boolean
      prompt: Use application.yml file for environment variables?
  - quiet_assets:
      type: boolean
      prompt: Reduce assets logger noise during development?
  - better_errors:
      type: boolean
      prompt: Improve error reporting with 'better_errors' during development?
