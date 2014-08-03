class History < ActiveRecord::Base
  has_many :history_todos
  has_many :todos, through: :history_todos
  belongs_to :user
  has_many :comments
end
