class FollowRequest < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followee_id }

  class_eval do
    enum status: { pending: 0, accepted: 1, declined: 2 }
  end
end
