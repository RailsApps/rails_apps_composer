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
unless rvmrc_detected || (prefs.has_key? :rvmrc)
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
  case config['local_env_file']
  when 'figaro'
    prefs[:local_env_file] = 'figaro'
  when 'foreman'
    prefs[:local_env_file] = 'foreman'
  end
end
if prefer :local_env_file, 'figaro'
  say_wizard "recipe creating application.yml file for environment variables with figaro"
  add_gem 'figaro', '>= 1.0.0.rc1'
elsif prefer :local_env_file, 'foreman'
  say_wizard "recipe creating .env file for development environment variables with foreman"
  add_gem 'foreman', :group => :development
end

## BETTER ERRORS
if config['better_errors']
  prefs[:better_errors] = true
end
if prefs[:better_errors]
  say_wizard "recipe adding better_errors gem"
  add_gem 'better_errors', :group => :development
  if RUBY_ENGINE == 'ruby'
    case RUBY_VERSION.split('.')[0] + "." + RUBY_VERSION.split('.')[1]
      when '2.1'
        add_gem 'binding_of_caller', :group => :development, :platforms => [:mri_21]
      when '2.0'
        add_gem 'binding_of_caller', :group => :development, :platforms => [:mri_20]
      when '1.9'
        add_gem 'binding_of_caller', :group => :development, :platforms => [:mri_19]
    end
  end
end

# Pry
if config['pry']
  prefs[:pry] = true
end
if prefs[:pry]
  say_wizard "recipe adding pry-rails gem"
  add_gem 'pry-rails', :group => [:development, :test]
  add_gem 'pry-rescue', :group => [:development, :test]
end

## Rubocop
if config['rubocop']
  prefs[:rubocop] = true
end
if prefs[:rubocop]
  say_wizard "recipe adding rubocop gem and basic .rubocop.yml"
  add_gem 'rubocop', :group => [:development, :test]
  copy_from_repo '.rubocop.yml'
end

## Disable Turbolinks
if config['disable_turbolinks']
  prefs[:disable_turbolinks] = true
end
if prefs[:disable_turbolinks]
  say_wizard "recipe removing support for Rails Turbolinks"
  stage_two do
    say_wizard "recipe stage two"
    gsub_file 'Gemfile', /gem 'turbolinks'\n/, ''
    gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''
    case prefs[:templates]
      when 'erb'
        gsub_file 'app/views/layouts/application.html.erb', /, 'data-turbolinks-track' => true/, ''
      when 'haml'
        gsub_file 'app/views/layouts/application.html.haml', /, 'data-turbolinks-track' => true/, ''
      when 'slim'
        gsub_file 'app/views/layouts/application.html.slim', /, 'data-turbolinks-track' => true/, ''
    end
  end
end

## BAN SPIDERS
if config['ban_spiders']
  prefs[:ban_spiders] = true
end
if prefs[:ban_spiders]
  say_wizard "recipe banning spiders by modifying 'public/robots.txt'"
  stage_two do
    say_wizard "recipe stage two"
    gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
    gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'
  end
end

## JSRUNTIME
case RbConfig::CONFIG['host_os']
  when /linux/i
    prefs[:jsruntime] = yes_wizard? "Add 'therubyracer' JavaScript runtime (for Linux users without node.js)?" unless prefs.has_key? :jsruntime
    if prefs[:jsruntime]
      say_wizard "recipe adding 'therubyracer' JavaScript runtime gem"
      add_gem 'therubyracer', :platform => :ruby
    end
end

stage_three do
  say_wizard "recipe stage three"
  say_wizard "recipe removing unnecessary files and whitespace"
  %w{
    public/index.html
    app/assets/images/rails.png
  }.each { |file| remove_file file }
  # remove temporary Haml gems from Gemfile when Slim is selected
  if prefer :templates, 'slim'
    gsub_file 'Gemfile', /.*gem 'haml2slim'\n/, "\n"
    gsub_file 'Gemfile', /.*gem 'html2haml'\n/, "\n"
  end
  # remove gems and files used to assist rails_apps_composer
  gsub_file 'Gemfile', /.*gem 'rails_apps_pages'\n/, ''
  gsub_file 'Gemfile', /.*gem 'rails_apps_testing'\n/, ''
  remove_file 'config/railscomposer.yml'
  # remove commented lines and multiple blank lines from Gemfile
  # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
  gsub_file 'Gemfile', /#.*\n/, "\n"
  gsub_file 'Gemfile', /\n^\s*\n/, "\n"
  remove_file 'Gemfile.lock'
  run 'bundle install --without production'
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
  stage_three do
    say_wizard "recipe stage three"
    say_wizard "recipe creating GitHub repository"
    git_uri = `git config remote.origin.url`.strip
    unless git_uri.size == 0
      say_wizard "Repository already exists:"
      say_wizard "#{git_uri}"
    else
      run "hub create #{app_name}"
      run "hub push -u origin master"
    end
  end
end

__END__

name: extras
description: "Various extras."
author: RailsApps

requires: [gems]
run_after: [gems, init]
category: other

config:
  - disable_turbolinks:
      type: boolean
      prompt: Disable Rails Turbolinks?
  - ban_spiders:
      type: boolean
      prompt: Set a robots.txt file to ban spiders?
  - github:
      type: boolean
      prompt: Create a GitHub repository?
  - local_env_file:
      type: multiple_choice
      prompt: Add gem and file for environment variables?
      choices: [ [None, none], [Add .env with Foreman, foreman], [Add application.yml with Figaro, figaro]]
  - quiet_assets:
      type: boolean
      prompt: Reduce assets logger noise during development?
  - better_errors:
      type: boolean
      prompt: Improve error reporting with 'better_errors' during development?
  - pry:
      type: boolean
      prompt: Use 'pry' as console replacement during development and test?
  - rubocop:
      type: boolean
      prompt: Use 'rubocop' to ensure that your code conforms to the Ruby style guide?
