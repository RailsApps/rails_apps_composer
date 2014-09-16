# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/email_dev.rb

prefs[:mailcatcher] = true if config['mailcatcher']
prefs[:mail_view] = true if config['mail_view']

if prefs[:mailcatcher]
  add_gem 'mailcatcher', group: :development
end
add_gem 'mail_view', group: :development if prefs[:mail_view]

stage_two do
  say_wizard "recipe stage two"
  if prefs[:mailcatcher]
    say_wizard "recipe installing mailcatcher"
    create_file 'config/initializers/mailcatcher.rb' do <<-RUBY
# Detect if mailcatcher is running and use that if available
if Rails.env.development?
  begin
    sock = TCPSocket.new("localhost", 1025)
    sock.close
    catcher = true
  rescue
    catcher = false
  end

  if catcher
    ActionMailer::Base.smtp_settings = { :host => "localhost", :port => '1025', }
    ActionMailer::Base.perform_deliveries = true
  end
end
RUBY
    end
    if prefer(:local_env_file, 'foreman') && File.exists?('Procfile.dev')
      append_file 'Procfile.dev', "mail: mailcatcher --foreground\n"
    end
    ### GIT
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: set up mailcatcher for development"' if prefer :git, true
  end
  if prefs[:mail_view]
    say_wizard "recipe installing mail_view"
    create_file 'app/mailers/mail_preview.rb' do <<-RUBY
class MailPreview < MailView
  # Pull data from existing fixtures
  #def invitation
  #  account = Account.first
  #  inviter, invitee = account.users[0, 2]
  #  Notifier.invitation(inviter, invitee)
  #end

  # Factory-like pattern
  #def welcome
  #  user = User.create!
  #  mail = Notifier.welcome(user)
  #  user.destroy
  #  mail
  #end

  # Stub-like
  #def forgot_password
  #  user = Struct.new(:email, :name).new('name@example.com', 'Jill Smith')
  #  mail = UserMailer.forgot_password(user)
  #end
end
RUBY
    end
    inject_into_file 'config/routes.rb', "mount MailPreview => 'mail_view' if Rails.env.development?", :before => "end"
    ### GIT
    git :add => '-A' if prefer :git, true
    git :commit => '-qm "rails_apps_composer: set up mail_view for development"' if prefer :git, true
  end
end

__END__

name: email_dev
description: "Add gems to help develop and debug emails locally sent by your app."
author: JangoSteve

category: development
requires: [setup]
run_after: [email, extras]
args: -T

config:
  - mailcatcher:
      type: boolean
      prompt: Use Mailcatcher to catch sent emails in development and display in web interface?
  - mail_view:
      type: boolean
      prompt: Add MailView routes to preview email layouts in development?
