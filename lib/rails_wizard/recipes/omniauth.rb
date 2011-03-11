require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class Omniauth < RailsWizard::Recipe
      name "OmniAuth"
      category "authentication"
      description "A basic setup of OmniAuth with a SessionsController to handle the request and callback phases."
    end
  end
end

__END__

gem 'omniauth'

after_bundler do
  file 'app/controllers/sessions_controller.rb', "class SessionsController < ApplicationController\n  def callback\n    auth # Do what you want with the auth hash!\n  end\n\n  def auth; request.env['omniauth.auth'] end\nend"
  route "match '/auth/:provider/callback', :to => 'sessions#callback'"
end
