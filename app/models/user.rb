class User < ActiveRecord::Base
  has_many :expense
  has_many :tag
	belongs_to :type

	validates :username, :presence => true, :uniqueness => true
	# validates :password, :presence => true
	validates :name, :presence => true
	validates :type_id, :presence => true

  	attr_accessible :name, :password, :type_id, :username

  	def self.check_login(username, password)
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

    def getTags
      tag.find(:all)
    end
end
