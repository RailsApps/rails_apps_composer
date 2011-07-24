gem "rails_config"

after_bundler do
  say_wizard "Generating RailsConfig files"
  generate "rails_config:install"
end

__END__

name: RailsConfig
description: "Easiest way to add multi-environment yaml settings to Rails3"
author: vegetables

category: other
tags: [utilities, configuration]
