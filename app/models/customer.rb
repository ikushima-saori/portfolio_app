class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  has_many :ideas, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :follower_customer, through: :follower, source: :followed
  has_many :followed_customer, through: :followed, source: :follower

  validates :name, presence: true
  validates :preference, presence: true
  validates :weak, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }

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
      customer.password = SecureRandom.urlsafe_base64
      customer.password_confirmation = customer.password
      customer.name = 'ゲスト'
      customer.preference = 'ゲストはTOPとaboutしか触れない' #バリデーションに引っかかるので必要
      customer.weak = 'ゲストはTOPとaboutしか触れない' #バリデーションに引っかかるので必要
      customer.is_active = true
    end
  end

  #Eメール正規化
  before_validation :normalize_email

  def active_for_authentication?
    super && (self.is_active == true)
  end

  def follow(customer)
    follower.create(followed_id: customer.id)
  end

  def unfollow(customer)
    follower.find_by(followed_id: customer.id).destroy
  end

  def following?(customer)
    follower_customer.include?(customer)
  end

  def follower_customers  # フォロワーを取得するメソッド
    Customer.joins(:follower)
            .where(follower: { followed_id: id, is_active: true }) # フォロワーの中でアクティブなユーザーのみ
  end

  def followed_customers  # フォローしているユーザーを取得するメソッド
    Customer.joins(:followed)
            .where(followed: { follower_id: id, is_active: true }) # フォローしている中でアクティブなユーザーのみ
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no_image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end
