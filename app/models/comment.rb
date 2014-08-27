class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :history

  validates :contents, presence: true
  validates :user, presence: true
end
