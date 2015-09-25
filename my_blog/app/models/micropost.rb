class Micropost < ActiveRecord::Base
    belongs_to :user
    validates :content, presence: true, length: { maximum: 4000 }
    default_scope -> { order('created_at DESC') }
    validates :user_id, presence: true
end
