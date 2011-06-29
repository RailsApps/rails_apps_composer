# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/navigation.rb

after_bundler do

  say_wizard "Navigation recipe running 'after bundler'"

    # Create navigation links
    if recipes.include? 'haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file "app/views/shared/_navigation.html.haml" do <<-'HAML'
- if user_signed_in?
  %li
    Logged in as #{current_user.name}
  %li
    = link_to('Logout', signout_path)
- else
  %li
    = link_to('Login', signin_path)
HAML
      end
    else
      create_file "app/views/shared/_navigation.html.erb" do <<-ERB
<% if user_signed_in? %>
  <li>
  Logged in as <%= current_user.name %>
  </li>
  <li>
  <%= link_to('Logout', signout_path) %>        
  </li>
<% else %>
  <li>
  <%= link_to('Login', signin_path)  %>  
  </li>
<% end %>
ERB
      end
    end

    # Add navigation links to the default application layout
    if recipes.include? 'html5'
      if recipes.include? 'haml'
        # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
        inject_into_file 'app/views/layouts/application.html.haml', :after => "%header\n" do <<-HAML
          %nav
            %ul.hmenu
              = render 'shared/navigation'
HAML
        end
      else
        inject_into_file 'app/views/layouts/application.html.erb', :after => "<header>\n" do
  <<-ERB
          <nav>
            <ul class="hmenu">
              <%= render 'shared/navigation' %>
            </ul>
          </nav>
ERB
        end
      end
    else
      if recipes.include? 'haml'
        # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
        inject_into_file 'app/views/layouts/application.html.haml', :after => "%body\n" do <<-HAML
  %ul.hmenu
    = render 'shared/navigation'
HAML
        end
      else
        inject_into_file 'app/views/layouts/application.html.erb', :after => "<body>\n" do
  <<-ERB
  <ul class="hmenu">
    <%= render 'shared/navigation' %>
  </ul>
ERB
        end
      end
    end

end

__END__

name: Navigation
description: "Add navigation links."
author: RailsApps

category: other
tags: [utilities, configuration]
