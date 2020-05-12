class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, dependent: :destroy

  def friends
    friendships.map { |f| f.friend if f.confirmed }.compact
  end

  def friend?(user)
    friends.include?(user)
  end

  def added?(user)
    user == self ||
    friendships.where(friend_id: user.id).exists? ||
    user.friendships.where(friend_id: self.id).exists?
  end
end
