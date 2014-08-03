class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
