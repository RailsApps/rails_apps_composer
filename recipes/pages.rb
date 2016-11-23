# Application template recipe for the rails_apps_composer. Change the recipe here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/pages.rb

stage_two do
  say_wizard "recipe stage two"
  case prefs[:pages]
    when 'home'
      generate 'pages:home -f'
    when 'about'
      generate 'pages:about -f'
    when 'users'
      generate 'pages:users -f'
      generate 'pages:roles -f' if prefer :authorization, 'roles'
      generate 'pages:authorized -f' if prefer :authorization, 'pundit'
    when 'about+users'
      generate 'pages:about -f'
      generate 'pages:users -f'
      generate 'pages:roles -f' if prefer :authorization, 'roles'
      generate 'pages:authorized -f' if prefer :authorization, 'pundit'
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: add pages"' if prefer :git, true
end

stage_four do
  say_wizard "recipe stage four"
  generate 'administrate:install' if prefer :dashboard, 'administrate'
  case prefs[:layouts]
    when 'bare'
      generate 'theme:bare -f'
    when 'blog_home'
      generate 'theme:blog_home -f'
    when 'business_casual'
      generate 'theme:business_casual -f'
    when 'business_frontpage'
      generate 'theme:business_frontpage -f'
    when 'clean_blog'
      generate 'theme:clean_blog -f'
    when 'four_col_portfolio'
      generate 'theme:four_col_portfolio -f'
    when 'full_width_pics'
      generate 'theme:full_width_pics -f'
    when 'heroic_features'
      generate 'theme:heroic_features -f'
    when 'landing_page'
      generate 'theme:landing_page -f'
    when 'modern_business'
      generate 'theme:modern_business -f'
    when 'one_col_portfolio'
      generate 'theme:one_col_portfolio -f'
    when 'one_page_wonder'
      generate 'theme:one_page_wonder -f'
    when 'portfolio_item'
      generate 'theme:portfolio_item -f'
    when 'round_about'
      generate 'theme:round_about -f'
    when 'shop_homepage'
      generate 'theme:shop_homepage -f'
    when 'shop_item'
      generate 'theme:shop_item -f'
    when 'simple_sidebar'
      generate 'theme:simple_sidebar -f'
    when 'small_business'
      generate 'theme:small_business -f'
    when 'stylish_portfolio'
      generate 'theme:stylish_portfolio -f'
    when 'the_big_picture'
      generate 'theme:the_big_picture -f'
    when 'three_col_portfolio'
      generate 'theme:three_col_portfolio -f'
    when 'thumbnail_gallery'
      generate 'theme:thumbnail_gallery -f'
    when 'two_col_portfolio'
      generate 'theme:two_col_portfolio -f'
  end
  ### GIT ###
  git :add => '-A' if prefer :git, true
  git :commit => '-qm "rails_apps_composer: add Bootstrap page layouts"' if prefer :git, true
end

__END__

name: pages
description: "Add pages"
author: RailsApps

requires: [setup, gems, frontend]
run_after: [setup, gems, frontend]
category: mvc
