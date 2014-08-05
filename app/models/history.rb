class History < ActiveRecord::Base
  has_many :history_todos
  has_many :todos, through: :history_todos

  has_many :history_users, foreign_key: :assigned_history_id
  has_many :assignees, through: :history_users

  belongs_to :user
  has_many :comments
end
