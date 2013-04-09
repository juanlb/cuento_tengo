# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_expensr_session',
  :secret      => '8e58d5f2913aab9b2f3914bd7ba5e030b6392e636bdd000d9681839b3f52bead549d4c719417f715028fcf2249281b785c79cebe686e00d7fe289f51dc0b0b3a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
