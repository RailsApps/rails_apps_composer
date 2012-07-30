# Application template recipe for the rails_apps_composer

if config['slim']
  gem 'slim', '~> 1.0'
  gem 'slim-rails', '~> 1.0.3', :group => :development
else
  recipes.delete('slim')
end

after_bundler do

  say_wizard "Slim recipe running 'after bundler'"

  remove_file 'app/views/layouts/application.html.erb'
  case config['slim_template']

    when 'default'
      # There is Slim code in this script. Changing the indentation is perilous between SLIMs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file 'app/views/layouts/application.html.slim' do
      <<-'SLIM'
doctype html
html
  head
    title App_Name
    = stylesheet_link_tag    "application", :media => "all"
    = javascript_include_tag "application"
    = csrf_meta_tags
  body
    = yield
SLIM
      end
      # Replace /App_Name/ with Rails project app name
      gsub_file 'app/views/layouts/application.html.slim', /App_Name/, "#{app_name.humanize.titleize}"
    when 'enhanced'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/views/layouts/application.html.slim', 'app/views/layouts/application.html.slim'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/views/layouts/_footer.html.slim', 'app/views/layouts/_footer.html.slim'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/views/layouts/_header.html.slim', 'app/views/layouts/_header.html.slim'
      get 'https://raw.github.com/akiva/rails-application-boilerplates/master/views/layouts/_messages.html.slim', 'app/views/layouts/_messages.html.slim'
      # If simple-navigation gem is not present, remove the line that renders
      # simple-navigation's config file and insert a navigation partial
      unless recipes.include? 'simple_navigation'
        gsub_file 'app/views/layouts/_header.html.slim', /== render_navigation/, '== render \'layouts/navigation\''
        # If OmniAuth or Devise are present, insert example navigation at the
        # bottom of the header partial
        if recipes.include? 'devise'
          if recipes.include? 'authorization'
            get 'https://raw.github.com/akiva/rails-application-boilerplates/master/views/navigation/devise/authorization/_navigation.html.slim', 'app/views/layouts/_navigation.html.slim'
          else
            get 'https://raw.github.com/akiva/rails-application-boilerplates/master/views/navigation/devise/_navigation.html.slim', 'app/views/layouts/_navigation.html.slim'
          end
        elsif recipes.include? 'omniauth'
          get 'https://raw.github.com/akiva/rails-application-boilerplates/master/views/navigation/omniauth/_navigation.html.slim', 'app/views/layouts/_navigation.html.slim'
        else
          get 'https://raw.github.com/akiva/rails-application-boilerplates/master/views/layouts/_navigation.html.slim', 'app/views/layouts/_navigation.html.slim'
        end
      end
    # Replace /App_Name/ with Rails project app name
    gsub_file 'app/views/layouts/application.html.slim', /App_Name/, "#{app_name.humanize.titleize}"
    gsub_file 'app/views/layouts/_footer.html.slim', /App_Name/, "#{app_name.humanize.titleize}"
    gsub_file 'app/views/layouts/_header.html.slim', /App_Name/, "#{app_name.humanize.titleize}"
  end

  # Add custom
  say_wizard "Adding custom Slim shortcut for 'role' attribute using '@' character"
  inject_into_file 'config/environment.rb', "Slim::Engine.set_default_options shortcut: { '@' => 'role', '#' => 'id', '.' => 'class'}\n\n", :before => "# Initialize the rails application\n"

end

__END__

name: SLIM
description: "Utilize Slim instead of ERB."
author: Akiva Levy

category: templating
exclusive: templating

config:
  - slim:
      type: boolean
      prompt: "Would you like to use Slim instead of ERB?"
  - slim_template:
      type: multiple_choice
      prompt: "Which Slim view templates would you like to generate?"
      choices: [["Default application layout", default], ["Enhanced application layout with partials", enhanced]]
