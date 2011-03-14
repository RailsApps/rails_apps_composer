gem 'right-rails'

after_bundler do
  generate 'right_rails'
end

__END__

name: RightJS
description: "Use RightJS in place of Prototype for this application."
author: mbleigh

exclusive: javascript_framework
category: assets
tags: [javascript, framework]

args: ["-J"]
