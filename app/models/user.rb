class User < ApplicationRecord

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  # いいねランキング用
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverse_of_relationships, source: :user
  has_many :user_rooms
  has_many :chats

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def following(other_user)
    self.relationships.find_by(follow_id: other_user.id)
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com', name: 'guest') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable, :recoverable,
          :trackable, :rememberable, :validatable, :confirmable

  validates :name, presence: true, uniqueness: true,
                   length: { minimum: 2, maximum: 10 }

  validates :profile, length: { maximum: 1000 }

  attachment :profile_image


end
