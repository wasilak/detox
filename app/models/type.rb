class Type < ActiveRecord::Base
	has_many :user

  attr_accessible :type
end
