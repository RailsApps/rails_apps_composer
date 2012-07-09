# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/preliminaries.rb

case config['ruby']
	when 'ruby_1_9_3'
    recipes << 'ruby_1_9_3'
	else
		raise StandardError.new "Aborted. Only Ruby 1.9.3 is supported."
end

case config['rails']
	when 'rails_3_2_6'
    recipes << 'rails_3_2_6'
	else
		raise StandardError.new "Aborted. Only Rails 3.2.6 is supported."
end

case config['database']
	when 'sqlite'
    recipes << 'sqlite'
  when 'mongodb'
    recipes << 'mongodb'
    say_wizard multiple_choice("Which ORM?", [["Mongoid","mongoid"],["Foobar","foobar"]])
	else
		raise StandardError.new "No database selected."
end

__END__

name: Preliminaries
description: "Specify choices for your application."
author: RailsApps

category: other
tags: [utilities, configuration]

config:
  - ruby:
      type: multiple_choice
      prompt: "Which Ruby version?"
      choices: [["Ruby 1.9.3", ruby_1_9_3]]
  - rails:
      type: multiple_choice
      prompt: "Which Rails version?"
      choices: [["Rails 3.2.6", rails_3_2_6]]
  - database:
      type: multiple_choice
      prompt: "Which database?"
      choices: [["SQLite", sqlite], ["MongoDB", mongodb]]