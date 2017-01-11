add_gem 'dotenv-rails'

stage_two do
  create_file ".env" do
    "#This .env file should contain sensible default values, and be committed to the repository.\n"
  end
end

__END__

name: inker_auth
description: "Add Inker Auth for authentication"
author: akolas

requires: [setup, gems]
run_after: [setup, gems]
category: customInk
