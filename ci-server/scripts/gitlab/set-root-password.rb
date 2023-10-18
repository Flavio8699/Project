#!/usr/bin/env ruby

user = User.where(id: 1).first # get first user in database (which is the admin)
user.password = '12345678' # set password
user.password_confirmation = '12345678' # confirm password
user.save! # save user