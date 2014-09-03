class DropReadableTypeLengthLimit < ActiveRecord::Migration
  def change
    change_column :read_marks, :readable_type, :string, null: false, limit: nil
  end
end
