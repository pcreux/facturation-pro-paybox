source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.2'
gem 'jquery-rails'

gem 'pg'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'

gem 'paybox_system'
gem 'dotenv'
gem 'virtus'
gem 'haml'
gem 'activeresource'
gem 'airbrake', '3.1.14'

gem "lograge"

group :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'zeus'
  gem 'vcr'
  gem 'webmock', '1.15'
end

group :production do
  gem 'passenger'

  # Enable gzip compression on heroku, but don't compress images.
  gem 'heroku-deflater'

  # Heroku injects it if it's not in there already
  gem 'rails_12factor'

end
