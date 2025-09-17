class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Follow system
  has_many :active_follow_requests,  class_name: "FollowRequest",
                                     foreign_key: "follower_id",
                                     dependent: :destroy
  has_many :passive_follow_requests, class_name: "FollowRequest",
                                     foreign_key: "followee_id",
                                     dependent: :destroy

  has_many :following, through: :active_follow_requests, source: :followee
  has_many :followers, through: :passive_follow_requests, source: :follower

  after_create :send_welcome_email

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
