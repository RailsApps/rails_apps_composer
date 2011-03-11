gem 'mongoid', '>= 2.0.0.beta.19'

after_bundler do
  generate 'mongoid:config'
end

__END__

category: orm
name: Mongoid
description: "Utilize MongoDB with Mongoid as the ORM."
