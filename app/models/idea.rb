class Idea < ApplicationRecord
  belongs_to :customer

  validates :introduction, presence: true

  def self.search_for(word, method)
    if method == 'perfect'
      Idea.where("introduction LIKE ?", "#{word}")
    elsif method == 'forward'
      Idea.where('introduction LIKE ?', "#{word}%")
    elsif method == 'backward'
      Idea.where('introduction LIKE ?', "%#{word}")
    else
      Idea.where('introduction LIKE ?', "%#{word}%")
    end
  end

end
