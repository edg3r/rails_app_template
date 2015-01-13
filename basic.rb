gem 'slim-rails'

gem 'russian', '~> 0.6.0'

gem_group :development do
  gem 'vendorer'
  gem 'pry'
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'quiet_assets'
end

gem_group :development, :test do
  gem 'rspec-rails'
end

run 'bundle install'
run 'rm -rf test'

generate 'rspec:install'

inject_into_file 'config/application.rb', after: '# config.i18n.default_locale = :de' do <<-EOS
    config.i18n.default_locale = :ru
    config.generators do |g|
      g.stylesheets false
      g.helper false
      g.javascripts false
      g.test_framework :rspec, fixtures: false
    end
EOS
end

frontend = ask("Do you want to use Bootstrap?(y/n)")
case frontend
when 'y'
  gem 'bootstrap-sass'
  gem 'autoprefixer-rails'

  run 'bundle install'
  run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss'
  insert_into_file 'app/assets/stylesheets/application.css.scss',
    "@import 'bootstrap-sprockets';\n@import 'bootstrap';\n",
    after: "*/\n"
  insert_into_file 'app/assets/javascripts/application.js',
    "//= require bootstrap-sprockets\n",
    after: "//= require jquery\n"

else
end


gem 'devise'
gem 'devise-i18n'

run 'bundle install'
generate 'devise:install'
user_model = ask("Choose user model for devise (empty for default).")
user_model = 'user' if user_model.blank?
generate 'devise', user_model

git :init
git add: '.'
git commit: "-m 'Initial commit'"


