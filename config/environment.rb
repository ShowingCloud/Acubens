# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Acubens::Application.initialize!

ENV['RAILS_ASSET_ID'] = `git log -1 --pretty=format:"%h"`
