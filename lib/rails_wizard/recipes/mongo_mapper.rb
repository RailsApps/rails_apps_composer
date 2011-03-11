require 'rails_wizard/recipe'

module RailsWizard
  module Recipes
    class MongoMapper < RailsWizard::Recipe
      name "MongoMapper"
      category "orm"
      description "Use MongoDB with MongoMapper as your primary datastore."
    end
  end
end

__END__

gem 'bson_ext'
gem 'mongo_mapper', :git => 'git://github.com/jnunemaker/mongomapper.git', :branch => 'rails3'

after_bundler do
  generate 'mongo_mapper:config'
end
