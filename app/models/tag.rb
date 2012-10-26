class Tag < ActiveRecord::Base
	has_and_belongs_to_many :expenses_tags_association
  	attr_accessible :name
end
