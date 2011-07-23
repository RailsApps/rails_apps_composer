gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

after_bundler do
  rake 'rails_admin:install'
  rake 'rails_admin:copy_assets'
  rake 'rails_admin:ckeditor_download' if config['ckeditor']
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

