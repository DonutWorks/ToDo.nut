class AddHistoryCountertoProject < ActiveRecord::Migration
  def change
    add_column :projects, :phistory_counter, :integer, :default => 0
    
  end
end
