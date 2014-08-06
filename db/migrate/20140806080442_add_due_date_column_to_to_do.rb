class AddDueDateColumnToToDo < ActiveRecord::Migration
  def change
  	add_column :todos, :duedate, :datetime
  end
end
