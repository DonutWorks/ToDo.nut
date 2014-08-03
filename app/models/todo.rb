class Todo < ActiveRecord::Base
  has_many :history_todos
  has_many :histories, through: :history_todos
end
