class AddHistoryCountertoProject < ActiveRecord::Migration
  def change
    add_column :projects, :history_counter, :inteager, :default => 0
    
  end
end
