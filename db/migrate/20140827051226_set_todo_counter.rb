class SetTodoCounter < ActiveRecord::Migration
  
  #local class for migration
  class Project < ActiveRecord::Base  
    has_many :todos
  end
  

  def up
    #initialize
    projects = Project.all
    projects.each do |p|
      puts p.todos.count
      p.update(:ptodo_counter => p.todos.count)
      
    end
  end
  def down
    projects = Project.all
    projects.each do |p|
      
      p.update(:ptodo_counter => 0)
      
    end
    
  end

end
