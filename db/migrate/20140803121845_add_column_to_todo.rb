class AddColumnToTodo < ActiveRecord::Migration
  def change
    add_column :todos, :color, :string
  end
end
