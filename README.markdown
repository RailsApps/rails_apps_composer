# RailsWizard Gem 

The RailsWizard gem is both the official repository of recipes for
[RailsWizard][1] as well as a stand-alone tool to generate rails
templates from the command line. The website and the gem are kept in
version sync, so any recipes released to the gem will be simultaneously
available on the web builder.

## Installation

Installation is simple:

    gem install rails_wizard

## Usage

The primary usage of the `rails_wizard` gem is to utilize its
interactive terminal command to build a Rails template. To get started,
you can simply run the command thusly:

    rails_wizard new APP_NAME

Where `APP_NAME` is the directory in which you wish to create the app
(it mirrors the Rails creation syntax). You will then be guided through
the recipe selection process and subsequently the Rails app generator
will automatically run with the template and all appropriate command
line options included.

### Specifying Recipes

If you wish to skip the interactive recipe selector, you may provide
instead a list of recipes with the `-r` option:

    rails_wizard new APP_NAME -r jquery mongo_mapper sass

This will automatically generate a Rails template with the provided
recipes and begin the app generator.

### Listing Recipes

You can also print out a simple list of recipes:

    rails_wizard list

Or print out a list of recipes for a specific category:

    rails_wizard list persistence

# RailsWizard Recipes

Previously stored in MongoDB, the RailsWizard recipe collection
now live in this GitHub repository to make them fork-friendly and
available for use with the command-line tool. You can see all of 
the recipes in the [recipes directory][2].

If you're looking for the web app source code, it now lives at
[rails_wizard.web][3].

## Submitting a Recipe

Submitting a recipe is actually a very straightforward process. Recipes
are made of up **template code** and **YAML back-matter** stored in a
ruby file. The `__END__` parsing convention is used so that each recipe
is actually a valid, parseable Ruby file. The structure of a recipe 
looks something like this:

    gem 'supergem'

    after_bundler do
      generate "supergem:install"
    end

    __END__

    category: templating
    name: SuperGem
    description: Installs SuperGem which is useful for things
    author: mbleigh

It's really that simple. The gem has RSpec tests that automatically
validate each recipe in the repository, so you should run `rake spec`
as a basic sanity check before submitting a pull request. Note that
these don't verify that your recipe code itself works, just that
RailsWizard could properly parse and understand your recipe file.

For more information on all available options for authoring recipes,
please see the 

## License

RailsWizard and its recipes are distributed under the MIT License.

[1]:http://railswizard.org/
[2]:https://github.com/intridea/rails_wizard/tree/master/recipes
[3]:https://github.com/intridea/rails_wizard.web
