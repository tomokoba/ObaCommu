class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  # いいねランキング用
  has_many :liked_users, through: :likes, source: :user
  has_many :photos, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_attachments_for :photos, attachment: :image
  validates :title, presence: true
  validates :caption, presence: true, length: { maximum: 1000 }
  validates :photos_images, presence: true, length: { maximum: 5, too_long: "は最大%{count}枚まで投稿できます" }

  def liked_by(user)
    # user_idとpost_idが一致するlikeを検索する
    Like.find_by(user_id: user.id, post_id: id)
  end
end
