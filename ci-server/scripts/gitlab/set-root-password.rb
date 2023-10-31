#!/usr/bin/env ruby

user = User.where(id: 1).first # get first user in database (which is the admin)
# Check if the user's password is already set
if user && user.encrypted_password.blank?
    user.password = '12345678' # set the password
    user.password_confirmation = '12345678' # confirm the password
    user.save! # save the user
end