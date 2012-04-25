if config['paperclip']
  if recipes.include? 'mongoid'
    gem 'mongoid-paperclip'
  else
    gem 'paperclip'
  end 
else
  recipes.delete('paperclip')
end

if config['paperclip']
  after_bundler do
    # Code here is run after Bundler installs all the gems for the project.
    # You can run generators and rake tasks in this section.
    if recipes.include? 'mongoid'
      create_file 'config/initializers/mongoid-paperclip.rb' do
        <<-RUBY
require 'mongoid_paperclip'
        RUBY
      end
    end

    if recipes.include? 'cloudfiles'
      # Add Storage module file for paperclip in lib
      get 'https://raw.github.com/gist/2476222/986bf7a49556ac549b75768af5dce2e6e4c67b61/Cloudfilesstorage.rb', 'lib/cloud_files_storage.rb'
      # Add config initialize file
      create_file 'config/initializers/cloudfiles.rb' do
        <<-RUBY
require 'cloudfiles'
require 'cloud_files_storage'
        RUBY
      end

      create_file 'config/rackspace_cloudfiles.yml' do 
        <<-YAML
DEFAULTS: &DEFAULTS
  username: [username]
  api_key: [api_key]

development:
  <<: *DEFAULTS
  container: [container name]

test:
  <<: *DEFAULTS
  container: [container name]

production:
  <<: *DEFAULTS
  container: [container name]
        YAML
      end
    end
  end
end

if config['paperclip']
  after_everything do
    # These blocks are run after the bundler blocks and are reserved for
    # special cases like committing the files to a git repository (something
    # that depends on everything having been generated).
  end
end
# A recipe is two parts: the Ruby code and YAML back-matter that comes
# after a blank line with the __END__ keyword.

__END__

name: Paperclip
description: "Use paperclip for file uploading."
author: merlinvn

category: persistence
tags: [storage]

config:
  - paperclip:
      type: boolean
      prompt: "Would you like to use Paperclip to store your files?"
