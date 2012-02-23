case config['guard']
  when 'no'
    recipes.delete('guard')
    say_wizard "Guard recipe skipped."
  when 'standard'
    # do nothing
  when 'LiveReload'
    recipes << 'guard-LiveReload'
  else
    recipes.delete('guard')
    say_wizard "Guard recipe skipped."
end


if recipes.include? 'guard'
  gem 'guard', '>= 0.6.2', :group => :development

  prepend_file 'Gemfile' do <<-RUBY
require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

RUBY
  end

  append_file 'Gemfile' do <<-RUBY
  # need newline here!
case HOST_OS
  when /darwin/i
    gem 'rb-fsevent', :group => :development
    gem 'growl', :group => :development
  when /linux/i
    gem 'libnotify', :group => :development
    gem 'rb-inotify', :group => :development
  when /mswin|windows/i
    gem 'rb-fchange', :group => :development
    gem 'win32console', :group => :development
    gem 'rb-notifu', :group => :development
end
  RUBY
  end

  def guards
    @guards ||= []
  end

  def guard(name, version = nil)
    args = []
    if version
      args << version
    end
    args << { :group => :development }
    gem "guard-#{name}", *args
    guards << name
  end

  guard 'bundler', '>= 0.1.3'

  unless recipes.include? 'pow'
    guard 'rails', '>= 0.0.3'
  end
  
  if recipes.include? 'guard-LiveReload'
    guard 'livereload', '>= 0.3.0'
  end

  if recipes.include? 'rspec'
    guard 'rspec', '>= 0.4.3'
  end

  if recipes.include? 'cucumber'
    guard 'cucumber', '>= 0.6.1'
  end

  after_bundler do
    run 'guard init'
    guards.each do |name|
      run "guard init #{name}"
    end
  end

else
  recipes.delete 'guard'
end

__END__

name: guard
description: "Automate your workflow with Guard"
author: ashley_woodard

run_after: [rspec, cucumber]
category: other
tags: [dev]

config:
  - guard:
      type: multiple_choice
      prompt: Would you like to use Guard to automate your workflow?
      choices: [["No", no], ["Guard default configuration", standard], ["Guard with LiveReload", LiveReload]]
