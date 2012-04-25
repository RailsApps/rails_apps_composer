if config['cloudfiles']
  gem 'cloudfiles'
else
  recipes.delete('cloudfiles')
end

if config['cloudfiles']
  after_bundler do
    # Code here is run after Bundler installs all the gems for the project.
    # You can run generators and rake tasks in this section.
  end
end

if config['cloudfiles']
  after_everything do
    # These blocks are run after the bundler blocks and are reserved for
    # special cases like committing the files to a git repository (something
    # that depends on everything having been generated).
  end
end
# A recipe is two parts: the Ruby code and YAML back-matter that comes
# after a blank line with the __END__ keyword.

__END__

name: Cloudfiles
description: "Use Cloudfiles to store files."
author: merlinvn

category: persistence
tags: [storage]

config:
  - cloudfiles:
      type: boolean
      prompt: "Would you like to use Cloudfiles to store your files?"
