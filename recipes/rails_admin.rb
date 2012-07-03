gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

after_bundler do
  generate 'rails_admin:install_admin'
  rake 'admin:copy_assets'
  rake 'admin:ckeditor_download' if config['ckeditor']
end

inject_into_file 'config/routes.rb', :after => "routes.draw do" do 
<<-RUBY
\n
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
\n  
RUBY
end

__END__

name: RailsAdmin
description: "Install RailsAdmin to manage data in your application"
author: alno

category: other

config:
  - ckeditor:
      type: boolean
      prompt: Install CKEditor?

