# Application template recipe for the rails_apps_composer.

if config['draggable']
  if recipes.include? 'jquery'
    if recipes.include? 'home_page'
      after_bundler do
        append_file 'app/views/home/index.html.erb' do <<-ERB
<div id="draggable" class="ui-widget-content"> 
  <p>Drag me around</p> 
</div> 
ERB
        end
        remove_file 'app/assets/javascripts/draggable.js'
        create_file 'app/assets/javascripts/draggable.js' do
          <<-ERB
$(function() { 
  $( "#draggable" ).draggable(); 
});
ERB
        end
      end
    end
  else
    say_wizard "You need to install jQuery to use the Draggable effect."
  end
end

__END__

name: Draggable
description: "Drag elements around page."
author: Andrew Dixon

category: assets

config:
  - draggable:
      type: boolean
      prompt: Would you like to add Draggable functionality?
