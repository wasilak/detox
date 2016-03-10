# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( locales/jquery.validationEngine-pl.js )
Rails.application.config.assets.precompile += %w( locales/jquery.validationEngine-en.js )
Rails.application.config.assets.precompile += %w( locales/bootstrap-datepicker.pl.js )
Rails.application.config.assets.precompile += %w( home.js )
Rails.application.config.assets.precompile += %w( expenses_percenteges.js )
Rails.application.config.assets.precompile += %w( expenses.js )
Rails.application.config.assets.precompile += %w( budgets.js )
Rails.application.config.assets.precompile += %w( application.js )
Rails.application.config.assets.precompile += %w( bootstrap.js )
Rails.application.config.assets.precompile += %w( global.js )
Rails.application.config.assets.precompile += %w( highcharts.js )
Rails.application.config.assets.precompile += %w( bootstrap-datepicker.js )
Rails.application.config.assets.precompile += %w( dataTables.bootstrap.js )
Rails.application.config.assets.precompile += %w( tags.js )
Rails.application.config.assets.precompile += %w( users.js )
