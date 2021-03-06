# bcrypt will generate the password hash
require 'bcrypt'

class User

  include DataMapper::Resource

  property :id, Serial
  property :email, String, :unique => true, :message => "This email is already taken"
  # this will store both the password and the salt
  # it's Text and not String because String holds 
  # 50 characters by default
  # and it's not enough for the hash and salt
  property :password_digest, Text
  # when assigned the password, we don't store it directly
  # instead, we generate a password digest, that looks like this:
  # "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and save it in the database. this digest, provided by bcrypt,
  # has both the password hash and the salt. we save it to the 
  # database instead of the plain password for security reasons.

  property :password_token, Text
  property :password_token_timestamp, Text


  def password=(password)
    @password = password
  	self.password_digest = BCrypt::Password.create(password)
  end

  attr_reader :password, :password_token, :password_token_timestamp
  attr_accessor :password_confirmation, :password_token, :password_token_timestamp

  # this is datamapper's method of validating the model
  # the model will not be saved unless both password
  # and password_confirmation are the same
  # read more about it at http://datamapper.org/docs/validations.html

  validates_confirmation_of :password, :message => "Sorry, your passwords don't match"

  def self.authenticate(email, password)
    # that's the user who is trying to sign in
    user = first(:email => email)
    # if this user exists and the password provided matches
    # the one we have password_digest for, everything's fine
    #
    # the Password.new returns an object that overrides the ==
    # method. instead of comparing two passwords directly
    # (which is impossible because we only have a one-way hash)
    # the == method calculates the candidate password_digest from
    # the password given and compares it to the password_digest
    # it was initialised with.
    # so, to recap: THIS IS NOT A STRING COMPARISON 
    if user && BCrypt::Password.new(user.password_digest) == password
      # return this user
      user
    else
      nil
    end
  end  

end