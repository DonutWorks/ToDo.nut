class AddImageToHistoryImages < ActiveRecord::Migration
  def change
    add_column :history_images, :image, :string
  end
end
