class SiteUser
  include ActiveModel::Model

  attr_accessor :email, :password

  def login_valid?
    email = ENV['ADMIN_EMAIL'] && password == ENV['ADMIN_PASSWORD']
  end
end