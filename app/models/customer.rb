class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  has_many :ideas, dependent: :destroy
  has_many :favorites, dependent: :destroy

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

  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.password_confirmation = customer.password
      customer.name = 'ゲスト'
      customer.preference = 'ミステリー・ポケモン・学園もの・仲間を庇って重症離脱からのピンチに復活シチュ'
      customer.weak = 'バッドエンド・三角関係からの1人がぼっちで終わる・バイオハザード'
      customer.is_active = true
    end
  end

  before_validation :normalize_email

  def active_for_authentication?
    super && (self.is_active == true)
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
