class Idea < ApplicationRecord
  belongs_to :customer
  has_many :favorites, dependent: :destroy
  has_many :idea_tags, dependent: :destroy
  has_many :tags, through: :idea_tags

  validates :introduction, presence: true
  validates :tags, presence: { message: "を入力してください" }, if: -> { tags.blank? }

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

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:word) unless self.tags.nil?  # 既にタグが存在していれば、タグの名前を配列として全て取得
    old_tags = current_tags - sent_tags  # 現在取得したタグから送られてきたタグを除いてoldtagとする
    new_tags = sent_tags - current_tags  # 送信されてきたタグから現在存在するタグを除いたタグをnewとする

    old_tags.each do |old|  # 古いタグを消す
      self.tags.delete(Tag.find_by(word: old))
    end

    new_tags.each do |new|  # 新しいタグを保存
      new_post_tag = Tag.find_or_initialize_by(word: new)
      self.tags << new_post_tag
   end
  end

  def tag_names
    tags.pluck(:word).join(', ')
  end

  def tag_names=(names)
    tag_names = names.split(',').map(&:strip).reject(&:empty?)
    self.tags = tag_names.map { |name| Tag.find_or_create_by(word: name) }
  end

  def favorited_by?(customer)
    favorites.where(customer_id: customer.id).exists?
  end

end
