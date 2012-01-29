# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/application_layout.rb

after_bundler do

  say_wizard "ApplicationLayout recipe running 'after bundler'"

  # Set up the default application layout
  if recipes.include? 'haml'
    remove_file 'app/views/layouts/application.html.erb'
    remove_file 'app/views/layouts/application.html.haml'
    # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
    create_file 'app/views/layouts/application.html.haml' do <<-HAML
!!! 5
%html
  %head
    %title #{app_name}
    = stylesheet_link_tag :application
    = javascript_include_tag :application
    = csrf_meta_tags
  %body
    - flash.each do |name, msg|
      = content_tag :div, msg, :id => "flash_#{name}" if msg.is_a?(String)
    = yield
HAML
    end
  else
    unless recipes.include? 'html5'
      inject_into_file 'app/views/layouts/application.html.erb', :after => "<body>\n" do
    <<-ERB
  <%- flash.each do |name, msg| -%>
    <%= content_tag :div, msg, :id => "flash_#{name}" if msg.is_a?(String) %>
  <%- end -%>
ERB
      end
    end
  end

end

__END__

name: ApplicationLayout
description: "Add a default application layout with flash messages."
author: RailsApps

category: other
tags: [utilities, configuration]
