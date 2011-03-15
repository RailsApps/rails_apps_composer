after_everything do
  git :init
  git :add => '.'
  git :commit => '-m "Initial import."'
end

__END__

name: Git
description: "Provides basic Git setup for the Rails app and commits the initial repository."
author: mbleigh

exclusive: scm
category: other
tags: [scm]
