create_file "test.txt", <<-TXT
foo
TXT

__END__

name: BTestRecipe
description: "Creates 'text.txt' for a test of sorting and execution order for RailsWizard recipes."
author: fortuity

run_before: [a_test_recipe]
category: other
tags: [utilities, configuration]