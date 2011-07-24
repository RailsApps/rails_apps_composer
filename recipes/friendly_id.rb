gem "friendly_id", "~> 3.3.0.rc2"

after_bundler do
  say_wizard "Generating FriendlyId files"
  generate "friendly_id"

  generate 'migration AddCachedSlugToUsers cached_slug:string'  
  inject_into_file 'app/models/user.rb', :before => '# Setup accessible' do
    "has_friendly_id :name, :use_slug => true, :approximate_ascii => true\n"
  end
end

__END__

name: FriendlyOd
description: "Add friendly_id slugs to users"
author: vegetables
requires: [add_user_name]

category: other
tags: [utilities, configuration]
