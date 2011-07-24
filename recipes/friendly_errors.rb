gem "friendly_errors"

after_bundler do
  say_wizard "Enabling FriendlyErrors"
  gsub_file 'app/models/user.rb', /protect_from_forgery/ do <<-RUBY
protect_from_forgery
  include FriendlyErrors
  use_friendly_errors
RUBY
  end
end

__END__

name: FriendlyErrors
description: "Shows user-friendly error pages instead of 'Something went wrong'"
author: vegetables

category: other
tags: [utilities, configuration]
