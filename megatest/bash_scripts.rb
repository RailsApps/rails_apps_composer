# Regarding problems experienced while shelling out, see:
# http://julialang.org/blog/2012/03/shelling-out-sucks/
# But the solution seems to be here:
# http://ruby-doc.org/stdlib-1.9.3/libdoc/shell/rdoc/Shell/CommandProcessor.html#method-i-system

CLONE_APP_REPOSITORIES_SCRIPT = <<BASH
# Clone Rails Example App repositories:
  repositories=$(cat repo-list)
  for repo in $repositories; do
    if test $repo != rails_apps_composer; then
      echo $repo:
      if ! test -d $repo; then
        (
          set -o xtrace
          git clone git@github.com:RailsApps/$repo.git
          cd $repo
          git remote rename origin upstream
        )
      fi
    fi
  done
)
BASH

CREATE_REPOSITORY_LIST_SCRIPT = <<BASH
# Create the repository list (keep utilities first):
  cat > repo-list <<HERE
rails_apps_composer
rails-composer
rails3-bootstrap-devise-cancan
rails3-devise-rspec-cucumber
rails3-mongoid-devise
rails3-mongoid-omniauth
rails3-subdomains
rails-prelaunch-signup
rails-recurly-subscription-saas
rails-stripe-membership-saas
HERE
)
BASH

FETCH_APP_UPDATES_SCRIPT = <<BASH
# Fetch Rails Example App updates:
  repositories=$(cat repo-list)
  for repo in $repositories; do
    echo
    echo $repo:
    (
      cd $repo
      pwd
      (
        set -o xtrace
        git fetch upstream
      )
    )
  done
)
BASH

GENERATE_APPS_SCRIPT = <<BASH
# Generate Rails Example Apps:
  repositories=$(cat repo-list)
  for repo in $repositories; do
    if ! (( test $repo = rails_apps_composer ||
            test $repo = rails-composer )); then
      echo $repo:
      (
        set -o xtrace
# On Mac OS X (& NetBSD), 'rm' lacks --force and --recursive (as spelled-out options).
        rm -rf $directory/$repo
        rails_apps_composer new $directory/$repo --quiet --verbose\\
        --recipes=$(echo $repo | sed s/-/_/g)_testing_recipe railsapps\\
        --recipe-dirs=rails_apps_composer/megatest/config\\
           --defaults=rails_apps_composer/megatest/config/$repo.yml
      )
    fi
  done
)
BASH

LIST_APP_REMOTES_SCRIPT = <<BASH
# List Rails Example App remotes:
  repositories=$(cat repo-list)
  for repo in $repositories; do
    echo
    echo $repo:
    (
      cd $repo
      git remote --verbose
    )
  done
)
BASH

MAKE_APPS_READ_SERVICE_ENV_VARS_SCRIPT = <<BASH
# Make Rails Example Apps read service key environment variables:
  sed_commands=$(pwd)/sed-commands.txt
  cat > $sed_commands <<CAT
       s/replace_with_your_recurly_api_key/<%= ENV[ %q{rac_test_RECURLY_API_KEY}        ] %>/
s/replace_with_your_recurly_js_private_key/<%= ENV[ %q{rac_test_RECURLY_JS_PRIVATE_KEY} ] %>/
                     s/Your_Stripe_API_key/<%= ENV[ %q{rac_test_STRIPE_API_KEY}         ] %>/
                  s/Your_Stripe_Public_Key/<%= ENV[ %q{rac_test_STRIPE_PUBLIC_KEY}      ] %>/
CAT
  repositories=$(cat repo-list)
  for repo in $repositories; do
    if ! (( test $repo = rails_apps_composer ||
            test $repo = rails-composer )); then
      echo
      echo $directory/$repo:
      (
        cd $directory/$repo
        pwd
        set -o xtrace
        git checkout --quiet master
        set +o errexit
# On Mac OS X (& NetBSD), 'sed' lacks --file and --in-place (as spelled-out options).
        sed -if $sed_commands config/application.yml; true
      )
      if test $repo = rails-prelaunch-signup; then
        echo
        (
          cd $directory/$repo
          set -o xtrace
          git checkout --quiet wip
          set +o errexit
          sed -if $sed_commands config/application.yml; true
        )
      fi
    fi
  done
  rm -f $sed_commands
)
BASH

MIGRATE_APP_DATABASES_SCRIPT = <<BASH
# Migrate Rails Example App databases:
  repositories=$(cat repo-list)
  for repo in $repositories; do
    if ! (( test $repo = rails_apps_composer ||
            test $repo = rails-composer )); then
      echo
      (
        cd $directory/$repo
        pwd
        (
          set -o xtrace
          git checkout --quiet master
          bundle exec rake db:migrate
          git status
        )
        if test $repo = rails-prelaunch-signup; then
          (
            set -o xtrace
            git checkout --quiet wip
            bundle exec rake db:migrate
            git status
          )
        fi
      )
    fi
  done
)
BASH

REBASE_APP_UPDATES_SCRIPT = <<BASH
# Rebase Rails Example App updates:
  repositories=$(cat repo-list)
  for repo in $repositories; do
    echo
    echo $repo:
    (
      cd $repo
      pwd
      (
        set -o xtrace
        git checkout master
        git rebase upstream/master master
      )
      if test $repo = rails-prelaunch-signup; then
        echo
        (
          set -o xtrace
# Till branch 'wip' is added to the GitHub repository, continue on error:
          set +o errexit
          git checkout wip
          git rebase upstream/wip wip; true
        )
      fi
    )
  done
)
BASH

SET_CLONED_DIRECTORY_SCRIPT = <<BASH
# Set the directory to run a parallel script on the cloned repositories:
(
  set -o errexit
  cd ..
  export directory=.
BASH

SET_GENERATED_DIRECTORY_SCRIPT = <<BASH
# Set the directory to run a parallel script on the generated repositories:
(
  set -o errexit
  cd ..
  export directory=generated
BASH

SHOW_APPS_GIT_STATUS_SCRIPT = <<BASH
# Show Rails Example Apps' git status
  repositories=$(cat repo-list)
  for repo in $repositories; do
    echo
    (
      set -o xtrace
      cd $directory/$repo
      pwd
      git status
    )
  done
)
BASH

TEST_APPS_SCRIPT = <<BASH
# Test Rails Example Apps:
  repositories=$(cat repo-list)
  for repo in $repositories; do
    if ! (( test $repo = rails_apps_composer ||
            test $repo = rails-composer )); then
      (
        echo $directory/$repo:
        cd $directory/$repo
        pwd
        (
          set -o xtrace
          git checkout --quiet master
          bundle exec rake
        )
        if test $repo = rails-prelaunch-signup; then
          (
            set -o xtrace
            git checkout --quiet wip
            bundle exec rake
          )
        fi
      )
    fi
  done
)
BASH
