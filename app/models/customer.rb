class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image

  #アソシエーション
  has_many :ideas, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :follower_customer, through: :follower, source: :followed
  has_many :followed_customer, through: :followed, source: :follower

  #バリデーション
  validates :profile_image, content_type: { in: ['image/jpg','image/jpeg','image/png'], message: 'はJPGかPNG形式で登録してください' }  #jpegとpngを許可(jpgはWindowsでのファイル名制限から生まれた短縮形)
  validates :name, presence: true
  validates :preference, presence: true
  validates :weak, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }  #URI=Rubyの定型でメアドを検証して、一般的な形式(format)以外をはじくバリデーション

  #検索用メソッド
  def self.search_for(word, method)
    if method == 'perfect'
      Customer.where("name LIKE ?", "#{word}")
    elsif method == 'forward'
      Customer.where("name LIKE ?", "#{word}%")
    elsif method == 'backward'
      Customer.where("name LIKE ?", "%#{word}")
    else
      Customer.where("name LIKE ?", "%#{word}%")
    end
  end

  #ゲストユーザーを設定
  GUEST_USER_EMAIL = "guest@example.com" #メールアドレスの変数定義
  def self.guest #
    find_or_create_by!(email: GUEST_USER_EMAIL) do |customer| #メールがゲストメールのユーザーがいなければ作成する
      customer.password = SecureRandom.urlsafe_base64 #パスワードはランダム生成
      customer.name = 'ゲスト'
      customer.preference = 'ゲストはTOPとaboutしか触れない' #遷移不可ページでしか見られないが、バリデーションに引っかかるので必要
      customer.weak = 'ゲストはTOPとaboutしか触れない' #遷移不可ページでしか見られないが、バリデーションに引っかかるので必要
      customer.is_active = true
    end
  end

  #メールアドレスの正規化をバリデーションチェックの前に行う
  before_validation :normalize_email  #↓privateで定義

  #ユーザーがログイン済みかどうか確認するメソッド
  def active_for_authentication?
    super && is_active? #deviseの認証OKかつis_activeが真(true)であること
  end

  #フォロー機能用のメソッド
  def follow(customer)  #customerをフォローするメソッド
    follower.create(followed_id: customer.id)  #フォロワーを作ってcustomeridと紐づける
  end
  def unfollow(customer)  #フォローを解除するメソッド
    follower.find_by(followed_id: customer.id).destroy  #フォロワーを探して削除する
  end
  def following?(customer)  #フォローしているか確認するメソッド
    follower_customer.include?(customer)  #follower_customerにcustomerが含まれているか確認
  end
  def follower_customers  # フォロワーを取得するメソッド
    Customer.joins(:follower)  #customerとfollowerのテーブルを結合する
            .where(follower: { followed_id: id, is_active: true }) # followerの中でアクティブなユーザーのみを含める
  end
  def followed_customers  # フォローしているユーザーを取得するメソッド
    Customer.joins(:followed)  #customerとfollowedのテーブルを結合する
            .where(followed: { follower_id: id, is_active: true }) # followedの中でアクティブなユーザーのみを含める
  end

  #プロフィール画像表示用メソッド(幅,高さを引数で渡せる)
  def get_profile_image(width, height)
    unless profile_image.attached?  #profile_imageがある、ではない場合=画像が無い場合の処理
      file_path = Rails.root.join('app/assets/images/no_image.jpg') #使用する画像のパスをfile_pathに代入
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg') #画像を紐づける(file_pathを開いて、no_image.jpgという名前の画像をjpegで添付する)
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end #引数指定のみでリサイズ無しだと、引数に対して登録画像のサイズがかけ離れている場合レイアウトが崩れるのでセットで設定する

  private

  def normalize_email  #メールアドレスが存在する場合、小文字に直して前後の空白を取り除いてself.emailに格納
    self.email = email.downcase.strip if email.present?
  end
end
