if config['bourbon']
  gem 'bourbon'
else
  recipes.delete('bourbon')
end

__END__

name: Bourbon
description: "Include Bourbon library for SASS."
author: Akiva Levy

category: assets
exclusive: sass_library

config:
  - bourbon:
      type: boolean
      prompt: Would you like to use the Bourbon library for SASS?

