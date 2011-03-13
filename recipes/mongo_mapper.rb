gem 'bson_ext'
gem 'mongo_mapper', :git => 'git://github.com/jnunemaker/mongomapper.git', :branch => 'rails3'

after_bundler do
  generate 'mongo_mapper:config'
end

__END__

name: MongoMapper
description: "Use MongoDB with MongoMapper as your primary datastore."
author: mbleigh

exclusive: orm 
category: persistence
tags: [mongodb, orm]

args: ["-O"]
