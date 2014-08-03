class History < ActiveRecord::Migration
  def change
  	add_column :histories, :evented_at, :datetime
  end
end
