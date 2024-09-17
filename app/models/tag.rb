class Tag < ApplicationRecord
  has_many :idea_tag, dependent: :destroy
  has_many :idea, through: :idea_tag

  validates :word, presence:true
end
