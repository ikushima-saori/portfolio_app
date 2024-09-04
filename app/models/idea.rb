class Idea < ApplicationRecord
  belongs_to :customer

  validates :introduction, presence: true
end
