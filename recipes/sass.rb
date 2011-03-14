unless recipes.include? 'haml'
  gem 'haml', '>= 3.0.0'
end

__END__

name: SASS
description: "Utilize SASS (through the HAML gem) for really awesome stylesheets!"
author: mbleigh

exclusive: css_replacement 
category: assets
tags: [css]
