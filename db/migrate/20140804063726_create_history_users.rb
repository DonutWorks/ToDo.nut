class CreateHistoryUsers < ActiveRecord::Migration
  def change
    create_table :history_users do |t|
      t.references :assigned_history, references: :history, index: true
      t.references :assignee, references: :user, index: true
      t.timestamps
    end
  end
end
