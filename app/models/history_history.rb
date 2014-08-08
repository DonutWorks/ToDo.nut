class HistoryHistory < ActiveRecord::Base
  belongs_to :history
  belongs_to :referencing_history, class_name: "History"
end
