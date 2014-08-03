class HistoryTodo < ActiveRecord::Base
  belongs_to :history
  belongs_to :todo
end
