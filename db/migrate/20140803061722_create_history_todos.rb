class CreateHistoryTodos < ActiveRecord::Migration
  def change
    create_table :history_todos do |t|
      t.references :history, index: true
      t.references :todo, index: true
      t.timestamps
    end
  end
end
