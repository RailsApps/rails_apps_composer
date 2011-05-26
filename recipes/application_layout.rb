# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/application_layout.rb

after_bundler do

  say_wizard "ApplicationLayout recipe running 'after bundler'"

  # Set up the default application layout
  if recipes.include? 'haml'
    remove_file 'app/views/layouts/application.html.erb'
    # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
    create_file 'app/views/layouts/application.html.haml' do <<-HAML
!!! 5
%html
  %head
    %title #{app_name}
    = stylesheet_link_tag :all
    = javascript_include_tag :defaults
    = csrf_meta_tag
  %body
    - flash.each do |name, msg|
      = content_tag :div, msg, :id => "flash_\#{name}" if msg.is_a?(String)
    = yield
HAML
    end
    if recipes.include? 'rails 3.1'
      gsub_file 'app/views/layouts/application.html.haml', /stylesheet_link_tag :all/, 'stylesheet_link_tag :application'
      gsub_file 'app/views/layouts/application.html.haml', /javascript_include_tag :defaults/, 'javascript_include_tag :application'
    end
  else
    inject_into_file 'app/views/layouts/application.html.erb', :after => "<body>\n" do
  <<-ERB
  <%- flash.each do |name, msg| -%>
    <%= content_tag :div, msg, :id => "flash_\#{name}" if msg.is_a?(String) %>
  <%- end -%>
ERB
    end
  end

end

__END__

name: ApplicationLayout
description: "Add a default application layout with flash messages."
author: RailsApps

category: other
tags: [utilities, configuration]
