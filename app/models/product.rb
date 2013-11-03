class Product < ActiveRecord::Base
	validates :title, presence: true,
                    length: { minimum: 5 }
                    
    belongs_to :category
end
