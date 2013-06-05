# require 'digest/sha1'


class User < ActiveRecord::Base


  attr_accessor :password

  before_create :encrypt_password

  validates_uniqueness_of :email
  validates :password, :length => { :in => 5..20 }, :confirmation => true
  validates :password_confirmation, :presence => true


  def self.authenticate(email, password)
    user = self.find_by_email(email)
    fresh_encryption = Digest::SHA1.hexdigest("#{user.salt}#{password}")
    user.encrypted_password == fresh_encryption ? user : nil 
  end


  private

  def encrypt_password
    self.salt = Digest::SHA1.hexdigest("#{self.email}#{Time.now}")
    self.encrypted_password = Digest::SHA1.hexdigest("#{self.salt}#{self.password}")
    self.password = nil
  end

end
