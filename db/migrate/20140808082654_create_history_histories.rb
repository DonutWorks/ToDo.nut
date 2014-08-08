class CreateHistoryHistories < ActiveRecord::Migration
  def change
    create_table :history_histories do |t|
      t.references :history, index: true
      t.references :referencing_history, references: :history, index: true
      t.timestamps
    end
  end
end
