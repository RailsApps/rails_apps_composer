if recipes.include? 'mongoid'
  gem 'formtastic', "~> 2.1.1"
  gem 'activeadmin-mongoid'
else
  gem 'activeadmin'
end
gem "meta_search",    '>= 1.1.0.pre'
# sass-rails is also required but is by default in rails


after_bundler do
	case config['user_model']
		when 'default'
			generate 'active_admin:install'
		when ''
			generate 'active_admin:install'
		when 'skip'
			generate 'active_admin:install --skip-users'
		else
			generate "active_admin:install #{config['user_model']}"
	end
end

__END__

name: ActiveAdmin
description: "Install Active Admin to build an administration zone data in your application"
author: systho

category: other

config:
  - user_model:
      type: string
      prompt: "What model will you use for admin users ? type 'skip' to skip this step (default is AdminUser)"

