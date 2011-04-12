gsub_file 'test.txt', /foo/, 'bar'

__END__

name: ATestRecipe
description: "Modifies 'text.txt' for a test of sorting and execution order for RailsWizard recipes."
author: fortuity

run_after: [b_test_recipe]
category: other
tags: [utilities, configuration]