run "ln -s #{destination_root} ~/.pow/#{app_name}"
say_wizard "App is available at http://#{app_name}.dev/"

__END__

name: Pow
description: "Automatically create a symlink for Pow."
author: mbleigh

category: other
tags: [dev]

