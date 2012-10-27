class Tag < ActiveRecord::Base
	belongs_to :expenses_tags_association
  	attr_accessible :name
end
