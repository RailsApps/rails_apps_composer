
after_bundler do

  say_wizard "HomePage recipe running 'after bundler'"

  # remove the default home page
  remove_file 'public/index.html'

  # create a home controller and view
  generate(:controller, "static home")

  # set up a simple home page (with placeholder content)
  if recipes.include? 'haml'
    remove_file 'app/views/static/home.html.haml'
    # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
    # We have to use single-quote-style-heredoc to avoid interpolation.
    create_file 'app/views/static/home.html.haml' do
    <<-'HAML'
%h3 Home
HAML
    end
  else
    remove_file 'app/views/static/home.html.erb'
    create_file 'app/views/static/home.html.erb' do
    <<-ERB
<h3>Home</h3>
ERB
    end
  end

  # set routes
  gsub_file 'config/routes.rb', /get \"static\/home\"/, 'root to: "static#home"'

end

__END__

name: StaticPage
description: "Create a simple home page (creates a static controller and view)."
author: RailsApps

category: other
tags: [utilities, configuration]
