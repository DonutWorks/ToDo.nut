class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: true
  enum event_type: %w(mention)

  acts_as_readable :on => :updated_at
end