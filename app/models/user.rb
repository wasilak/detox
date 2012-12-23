class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
         #, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
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

    def self.find_for_open_id(access_token, signed_in_resource=nil)
      data = access_token['info']

      if user = User.where(:email => data['email']).first
      return user
      else #create a user with stub pwd
        # User.create!(:email => data['email'], :password => Devise.friendly_token[0,20])
        # redirect_to :controller => :user, :action => :index
      end
    end
end
