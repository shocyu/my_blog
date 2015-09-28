class Micropost < ActiveRecord::Base
    belongs_to :user, class_name: "User", foreign_key: "user_id"
    
    STATUS_VALUES = %w(draft user_only public)
    
    validates :title, presence: true, length: { maximum: 200 }
    validates :content, presence: true, length: { maximum: 4000 }
    default_scope -> { order('created_at DESC') }
    validates :user_id, presence: true
    validates :status, inclusion: { in: STATUS_VALUES }
    
    scope :common, -> { where(status: "public") }
    scope :published, -> { where("status <> ?", "draft") }
    scope :full, ->(user) {
        where("status <> ? OR user_id = ?", "draft", user.id) }
    scope :readable_for, ->(user) { user ? full(user) : common }
    
    scope :open, -> {
        now = Time.current
        where("posted_at <= ?", now) }
    
    class << self
        def status_text(status)
            I18n.t("activerecord.attributes.micropost.status_#{status}")
        end

        def status_options
            STATUS_VALUES.map { |status| [status_text(status), status] }
        end

        def sidebar_entries(user, num)
            readable_for(user).order(posted_at: :desc).limit(num)
        end
    end
  
end
