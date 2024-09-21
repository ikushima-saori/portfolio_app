class Favorite < ApplicationRecord
  belongs_to :customer
  belongs_to :idea

  validates :customer_id, uniqueness: {scope: :idea_id}

end
