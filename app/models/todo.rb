class Todo < ActiveRecord::Base

  before_create :ptodo_counter_increment
  
  has_many :history_todos
  has_many :histories, through: :history_todos
  belongs_to :user
  belongs_to :project
  
  def self.fetch_list_from(id, count)
    where(arel_table[:id].gteq(id)).take(count)
  end

  private
  def ptodo_counter_increment
    self.ptodo_id = self.project.ptodo_counter + 1
    self.project.update(:ptodo_counter => self.project.ptodo_counter + 1)
    
  end
end
