# Be sure to restart your server when you modify this file.

# Acubens::Application.config.session_store :cookie_store, key: '_Acubens_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Acubens::Application.config.session_store :redis_store,
	servers: ["#{Rails.configuration.database_configuration[Rails.env]["redis"]}/session"],
	expire_after: 7.days,
	key: "_Acubens_session",
	threadsafe: false
