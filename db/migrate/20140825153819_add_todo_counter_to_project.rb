class AddTodoCounterToProject < ActiveRecord::Migration
  
  #local class for migration
  class Project < ActiveRecord::Base  
    has_many :todos
  end

  def up
    add_column :projects, :ptodo_counter, :integer, :default => 0

    #initialize
    projects = Project.all
    projects.each do |p|
      
      p.update(:ptodo_counter => p.todos.count)
    
    end
  end
  def down
    remove_column :projects, :ptodo_counter, :integer, :default => 0
  end
end
