class AddAttachmentImageToHistoryImages < ActiveRecord::Migration
  def self.up
    change_table :history_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :history_images, :image
  end
end
