#!/usr/bin/env ruby

# Source: https://docs.gitlab.com/ee/user/profile/account/create_accounts.html

email = 'dev@project.com'
username = 'Owner'

# Check if a user with the given email or username already exists
existing_user = User.find_by(email: email) || User.find_by(username: username)

if not existing_user
    u = User.new(username: username, email: email, name: 'Owner Name', password: '12345678', password_confirmation: '12345678')
    u.skip_confirmation! # Use it only if you wish user to be automatically confirmed. If skipped, user receives confirmation e-mail
    u.save!

    # Create access token for the user such that we can use the API to POST a new project
    t = PersonalAccessToken.new
    t.user_id=User.find_by(username: username).id
    t.name='default'
    t.scopes=['api']
    t.set_token('abcdefghijklmnopqrstuvwxyz')
    t.save!
end