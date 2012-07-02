# Internal recipe for adding standalone gems that don't need full recipes
#
# Specify gems with -g on the command line: -g gem1 gem2 gem3
#
# If you're running interactively, enter the name of a gem when prompted
# for another recipe.
#
# Or, in a defaults file list the gems you want added after the rest of the
# recipes have run, like:
#   recipes:
#   - home_page
#
#   gems:
#   - d3_rails
#   - debugger
#
# You can parameterize the gem definition, like this (don't forget the colon
# after the gem name!)
#   gems:
#   - my_gem:
#     - "~> 1.1.0"
#     - require: false

if config['gems']
  config['gems'].each do |gem_name|
    case gem_name
      when Hash
        args = gem_name.flatten.flatten
        args[0] = args[0].dup # avoid frozen string exception
        gem *args
      else
        gem gem_name
    end
  end
end

__END__

name: gems
description: "Internal recipe for adding gems"
author: RailsApps
category: internal
