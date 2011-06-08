# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/haml.rb

if config['haml']
  if recipes.include? 'rails 3.0'
    # for Rails 3.0, use only gem versions we know that work
    gem 'haml', '3.1.1'
    gem 'haml-rails', '0.3.4', :group => :development
  else
    # for Rails 3.1+, use optimistic versioning for gems
    gem 'haml', '>= 3.1.2'
    gem 'haml-rails', '>= 0.3.4', :group => :development
  end
else
  recipes.delete('haml')
end

__END__

name: HAML
description: "Utilize Haml instead of ERB."
author: RailsApps

category: templating
exclusive: templating

config:
  - haml:
      type: boolean
      prompt: Would you like to use Haml instead of ERB?