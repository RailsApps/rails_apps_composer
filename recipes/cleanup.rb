# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/cleanup.rb

after_bundler do

  say_wizard "Cleanup recipe running 'after bundler'"

  # remove unnecessary files
  %w{
    README
    doc/README_FOR_APP
    public/index.html
  }.each { |file| remove_file file }
  
  if recipes.include? 'rails 3.0'
    %w{
      public/images/rails.png
    }.each { |file| remove_file file }
  else
    %w{
      app/assets/images/rails.png
    }.each { |file| remove_file file }
  end
  
  # add placeholder READMEs
  get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/sample_readme.txt", "README"
  get "https://raw.github.com/RailsApps/rails3-application-templates/master/files/sample_readme.textile", "README.textile"
  gsub_file "README", /App_Name/, "#{app_name.humanize.titleize}"
  gsub_file "README.textile", /App_Name/, "#{app_name.humanize.titleize}"

  # remove commented lines from Gemfile
  # thanks to https://github.com/perfectline/template-bucket/blob/master/cleanup.rb
  gsub_file "Gemfile", /#.*\n/, "\n"
  gsub_file "Gemfile", /\n+/, "\n"

end

__END__

name: Cleanup
description: "Remove unnecessary files left over from generating a new Rails app."
author: RailsApps

category: other
tags: [utilities, configuration]
