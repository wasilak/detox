class Tag < ActiveRecord::Base
	has_many :expenses_tags_association
  	attr_accessible :name
end
