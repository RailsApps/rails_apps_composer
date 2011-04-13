# Application template recipe for the rails3_devise_wizard. Check for a newer version here:
# https://github.com/fortuity/rails3_devise_wizard/blob/master/recipes/home_page.rb

after_bundler do
  
  # remove the default home page
  remove_file 'public/index.html'
  
  # create a home controller and view
  generate(:controller, "home index")

  # set up a simple home page (with placeholder content)
  if recipes.include? 'haml'
    remove_file 'app/views/home/index.html.haml'
    # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
    # We have to use single-quote-style-heredoc to avoid interpolation.
    create_file 'app/views/home/index.html.haml' do 
    <<-'HAML'
%h3 Home
HAML
    end
  else
    remove_file 'app/views/home/index.html.erb'
    create_file 'app/views/home/index.html.erb' do 
    <<-ERB
<h3>Home</h3>
ERB
    end
  end

  # set routes
  gsub_file 'config/routes.rb', /get \"home\/index\"/, 'root :to => "home#index"'

end

__END__

name: HomePage
description: "Create a simple home page (with a home controller and view)."
author: fortuity

category: other
tags: [utilities, configuration]
