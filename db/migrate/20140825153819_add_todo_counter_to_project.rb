class AddTodoCounterToProject < ActiveRecord::Migration
  def change
    add_column :projects, :todo_counter, :inteager, :default => 0

    #initialize
    projects = Project.all
    projects.each do |p|
      
      p.update(:todo_counter => p.todos.count)
    
    end
  end
end
