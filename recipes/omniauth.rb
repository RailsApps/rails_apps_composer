gem 'omniauth', '~> 0.2.0'

after_bundler do
  file 'app/controllers/sessions_controller.rb', "class SessionsController < ApplicationController\n  def callback\n    auth # Do what you want with the auth hash!\n  end\n\n  def auth; request.env['omniauth.auth'] end\nend"
  route "match '/auth/:provider/callback', :to => 'sessions#callback'"
end

__END__

name: OmniAuth
description: "A basic setup of OmniAuth with a SessionsController to handle the request and callback phases."
author: mbleigh

exclusive: authentication
category: authentication
