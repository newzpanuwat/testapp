class Product < ApplicationRecord
  belongs_to :category
  validates :name, 
            presence: true, 
            uniqueness: { scope: :category_id },
            length: { maximum: 100 }
end