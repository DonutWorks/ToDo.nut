class HistoryImage < ActiveRecord::Base
  belongs_to :history
  mount_uploader :image, HistoryImageUploader
end
