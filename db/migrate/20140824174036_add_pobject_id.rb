class AddPobjectId < ActiveRecord::Migration
  def change
    
    add_column :todos, :ptodo_id, :inteager
    add_column :histories, :phistory_id, :inteager

  end
end
