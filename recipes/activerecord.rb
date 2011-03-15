config['database'] = 'oracle'

after_bundler do
  if config['database']
    say_wizard "Configuring '#{config['database']}' database settings..."
    old_gem = gem_for_database
    @options[:database] = config['database']
    gsub_file "gem '#{old_gem}'", "gem '#{gem_for_database}'"
    template "config/databases/#{@options[:database]}.yml", "config/database.yml"
    rake "db:create:all" 
  end
end

__END__

name: ActiveRecord
description: "Use the default ActiveRecord database store."
author: mbleigh

exclusive: orm
category: persistence
tags: [sql, defaults, orm]

config:
  - database:
      type: multiple_choice
      prompt: "Which database are you using?"
      choices:
        - ["MySQL", mysql]
        - ["Oracle", oracle]
        - ["PostgreSQL", postgresql]
        - ["SQLite", sqlite3]
        - ["Frontbase", frontbase]
        - ["IBM DB", ibm_db]
