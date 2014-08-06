class CreateHistoryImages < ActiveRecord::Migration
  def change
    create_table :history_images do |t|
      t.references :history, index: true

      t.timestamps
    end
  end
end
