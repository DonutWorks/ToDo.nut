class AddPobjectId < ActiveRecord::Migration
  def change
    
    add_column :todos, :ptodo_id, :integer
    add_column :histories, :phistory_id, :integer

  end
end
