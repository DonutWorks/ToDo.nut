class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.references :subject, polymorphic: true
      t.integer :event_type, null: false
      t.timestamps
    end
  end
end
