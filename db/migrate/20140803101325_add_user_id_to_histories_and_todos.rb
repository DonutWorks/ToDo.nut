class AddUserIdToHistoriesAndTodos < ActiveRecord::Migration
  def change
    add_column :todos, :user_id, :integer
    add_column :histories, :user_id, :integer
  end
end
