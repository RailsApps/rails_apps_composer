gem 'bson_ext'
gem 'mongo_mapper', :git => 'git://github.com/jnunemaker/mongomapper.git', :branch => 'rails3'

after_bundler do
  generate 'mongo_mapper:config'
end

__END__

category: orm
name: MongoMapper
description: "Use MongoDB with MongoMapper as your primary datastore."
