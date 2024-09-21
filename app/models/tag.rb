class Tag < ApplicationRecord
  has_many :idea_tags, dependent: :destroy
  has_many :ideas, through: :idea_tags
end
