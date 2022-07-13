class Subscription < ApplicationRecord
  validates :user_id, presence: true, uniqueness: {scope: :repository_id}

  scope :list, (lambda do |rid, uid|
    where(repository_id: rid).where.not user_id: uid
  end)
end
