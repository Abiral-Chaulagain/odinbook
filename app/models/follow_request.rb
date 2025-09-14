class FollowRequest < ApplicationRecord
  enum status: { pending: 0, accepted: 1, declined: 2 }

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id }
end
