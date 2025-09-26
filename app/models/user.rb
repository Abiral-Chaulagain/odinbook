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
  has_many :outgoing_follow_requests,  class_name: "FollowRequest",
                                     foreign_key: "follower_id",
                                     dependent: :destroy
  has_many :incoming_follow_requests, class_name: "FollowRequest",
                                     foreign_key: "followee_id",
                                     dependent: :destroy

  after_create :send_welcome_email, :create_profile

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end

  def create_profile
    Profile.create(user: self)
  end
end
