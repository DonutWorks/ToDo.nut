class Todo < ActiveRecord::Base
  has_many :history_todos
  has_many :histories, through: :history_todos
  belongs_to :user
  belongs_to :project
  
  def self.fetch_list_from(id, count)
    where(arel_table[:id].gteq(id)).take(count)
  end
end
