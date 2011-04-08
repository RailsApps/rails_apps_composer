gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

after_bundler do
  generate 'rails_admin:install_admin'
  rake 'admin:copy_assets'
  rake 'admin:ckeditor_download' if config['ckeditor']
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

