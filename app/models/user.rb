class User < ActiveRecord::Base
  attr_accessible :name, :password, :type, :username
end
