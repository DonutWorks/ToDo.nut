class AddTodoCounterToProject < ActiveRecord::Migration
  


  def change
    add_column :projects, :ptodo_counter, :integer, :default => 0

    
  end
  
end
