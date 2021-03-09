class User < ApplicationRecord
  
  has_many :posts, dependent: :destroy
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true,
                   length: { minimum: 2, maximum: 10 }

  validates :profile, length: { maximum: 1000 }

  attachment :profile_image


  def short_email
    email[0, 25] + '...'
  end
end
