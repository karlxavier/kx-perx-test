source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.6"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'aasm'
gem 'rspec-rails'
gem 'sidekiq'

group :development, :test do
  gem 'byebug'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'factory_bot_rails', require: false
  gem 'faker'
  gem 'shoulda-matchers'
end

group :test do
  gem 'rspec-sidekiq'
end

