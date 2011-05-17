# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/fortuity/rails_apps_composer/blob/master/recipes/devise_navigation.rb

after_bundler do

  say_wizard "DeviseNavigation recipe running 'after bundler'"

    # Create navigation links for Devise
    if recipes.include? 'haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file "app/views/devise/menu/_login_items.html.haml" do <<-'HAML'
- if user_signed_in?
  %li
    = link_to('Logout', destroy_user_session_path)
- else
  %li
    = link_to('Login', new_user_session_path)
HAML
      end
    else
      create_file "app/views/devise/menu/_login_items.html.erb" do <<-ERB
<% if user_signed_in? %>
  <li>
  <%= link_to('Logout', destroy_user_session_path) %>        
  </li>
<% else %>
  <li>
  <%= link_to('Login', new_user_session_path)  %>  
  </li>
<% end %>
ERB
      end
    end

    if recipes.include? 'haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file "app/views/devise/menu/_registration_items.html.haml" do <<-'HAML'
- if user_signed_in?
  %li
    = link_to('Edit account', edit_user_registration_path)
- else
  %li
    = link_to('Sign up', new_user_registration_path)
HAML
      end
    else
      create_file "app/views/devise/menu/_registration_items.html.erb" do <<-ERB
<% if user_signed_in? %>
  <li>
  <%= link_to('Edit account', edit_user_registration_path) %>
  </li>
<% else %>
  <li>
  <%= link_to('Sign up', new_user_registration_path)  %>
  </li>
<% end %>
ERB
      end
    end

    # Add navigation links to the default application layout
    if recipes.include? 'haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      inject_into_file 'app/views/layouts/application.html.haml', :after => "%body\n" do <<-HAML
  %ul.hmenu
    = render 'devise/menu/registration_items'
    = render 'devise/menu/login_items'
HAML
      end
    else
      inject_into_file 'app/views/layouts/application.html.erb', :after => "<body>\n" do
  <<-ERB
  <ul class="hmenu">
    <%= render 'devise/menu/registration_items' %>
    <%= render 'devise/menu/login_items' %>
  </ul>
ERB
      end
    end

end

__END__

name: DeviseNavigation
description: "Add navigation links for Devise."
author: fortuity

requires: [devise]
category: other
tags: [utilities, configuration]
