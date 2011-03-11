# RailsWizard Gem 

This is the official gem collection of recipes for [RailsWizard][1], the
online Rails template generator. Previously stored in MongoDB, the
recipes now live in a GitHub repository to make them fork-friendly. You
can see all of the recipes in the [recipes directory][2].

If you're looking for the web app source code, it now lives at
[rails_wizard-web][3].

## Submitting a Recipe

Submitting a recipe is actually a very straightforward process. Recipes
are made of up **template code** and **YAML back-matter** stored in a
ruby file. The `__END__` parsing convention is used so that each recipe
is actually a valid, parseable Ruby file. The structure of a recipe 
looks something like this:

```ruby
gem 'supergem'

after_bundler do
  generate "supergem:install"
end

__END__

category: templating
name: SuperGem
description: Installs SuperGem which is useful for things
author: mbleigh
```

It's really that simple. The gem has RSpec tests that automatically
validate each recipe in the repository, so you should run `rake spec`
as a basic sanity check before submitting a pull request. Note that
these don't verify that your recipe code itself works, just that
RailsWizard could properly parse and understand your recipe file.

## License

RailsWizard and its recipes are distributed under the MIT License.

[1]:http://railswizard.org/
[2]:https://github.com/intridea/rails_wizard/tree/master/recipes
[3]:https://github.com/intridea/rails_wizard-web
