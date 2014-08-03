class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :history, index: true
      t.string :contents

      t.timestamps
    end
  end
end
