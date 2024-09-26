class Idea < ApplicationRecord
  belongs_to :customer
  has_many :favorites, dependent: :destroy
  has_many :idea_tags, dependent: :destroy
  has_many :tags, through: :idea_tags
  attr_accessor :tag_list  #@tag_listの変数を簡単に読み書きできるようにする

  #タグ更新時用のメソッド ※tagモデルのバリデーションを表示させるために、エラーメッセージをerrorsに格納する必要がある
  after_update :update_save_tag  #controllerの@idea.updataが呼び出されたら実行
  def update_save_tag
    pp self.tag_list
    tag_list = self.tag_list.split(",").map { |tag| tag.gsub("　", "").strip }
    current_tags = self.tags.pluck(:word) unless self.tags.nil?  # 既にタグが存在していれば、タグの名前を配列として全て取得
    old_tags = current_tags - tag_list  # 現在取得したタグから送られてきたタグを除いてoldtagとする
    new_tags = tag_list - current_tags  # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    old_tags.each do |old|  # 古いタグを消す
      self.tags.delete(Tag.find_by(word: old))
    end
    new_tags.each do |new|  # 新しいタグを保存
      new_post_tag = Tag.find_or_initialize_by(word: new)
      begin
        self.tags << new_post_tag
      rescue => e
        if new_post_tag.errors.full_messages.size > 1
          self.errors.add(:tags, new_post_tag.errors.full_messages[1])
        end
        raise e  #updataにエラーが出ていることを教える　なかったらエラーなのに正常処理として進めてしまう
      end
   end
  end

  #バリデーション
  validates :introduction, presence: true
  validates :tags, presence: true

  #検索用メソッド
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

  #タグ用メソッド
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
  def tag_names  #タグ表示用メソッド　カンマ区切りで表示させる
    tags.pluck(:word).join(', ')
  end
  def tag_names=(names)  #タグをカンマ区切りで分割して各タグを保存するメソッド
    tag_names = names.split(',').map(&:strip).reject(&:empty?)
    self.tags = tag_names.map { |name| Tag.find_or_create_by(word: name) }
  end

  #いいね用メソッド
  def favorited_by?(customer)
    favorites.where(customer_id: customer.id).exists?
  end

end
