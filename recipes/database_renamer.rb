
unless config['username'].blank?
  gsub_file 'config/database.yml', "username: #{app_name}", "username: #{config['username']}"
end

__END__

name: DatabaseRenamer
description: "Change the username for the current database"
author: vegetables

category: other
tags: [utilities, configuration]

config:
  - username:
      prompt: "What's your database username? (Leave blank to use the default)"
      type: string