class HistoryUser < ActiveRecord::Base
  belongs_to :assigned_history, class_name: "History"
  belongs_to :assignee, class_name: :"User"
end