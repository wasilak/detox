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
      password_hashed = Digest::MD5.hexdigest(password)

      user = User
        .where(:username => username)
        .where(:password => password_hashed)
        .first
  		#user = User.find(
  		#	:all,
  		#	:conditions	=>	["username = ? and password = ?", "#{username}", "#{password_hashed}"]
  		#	)

      # Rails.logger.debug("user to check: #{username} : #{password} (#{password_hashed})")

      unless user.nil?
        return user
      end
  	end

    def get_tags
      tag.all
    end
end
