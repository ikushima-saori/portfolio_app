class Tag < ApplicationRecord
  has_many :idea_tags, dependent: :destroy
  has_many :ideas, through: :idea_tags

  validates :word, presence: true, uniqueness: true, format: { without: /\A[[:space:]]*\z/, message: "に空白は使えません" }

  before_save :strip_whitespace  #saveの前に空白を削除する

  private

  def strip_whitespace
    self.word = word.strip unless word.nil?
  end
end
