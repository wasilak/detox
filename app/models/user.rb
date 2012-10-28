class User < ActiveRecord::Base
	has_many :expense

	validates :username, :presence => true, :uniqueness => true
	validates :password, :presence => true
	validates :name, :presence => true
	validates :userType, :presence => true

  	attr_accessible :name, :password, :userType, :username

  	def self.checkLogin(username, password)
      passwordHashed = Digest::MD5.hexdigest(password)

  		user = User.find(
  			:all,
  			:conditions	=>	["username = ? and password = ?", "#{username}", "#{passwordHashed}"]
  			)

      # Rails.logger.debug("user to check: #{username} : #{password} (#{passwordHashed})")

      if user.count == 1
        return user[0]
      else
        return false
      end
  	end

end
