class History < ActiveRecord::Base
  has_many :history_todos
  has_many :todos, through: :history_todos

  has_many :history_users, foreign_key: :assigned_history_id
  has_many :assignees, through: :history_users

  belongs_to :user
  belongs_to :project
  
  has_many :comments

  has_many :images, :foreign_key => 'history_id', :class_name => 'HistoryImage'

  has_many :history_histories, dependent: :destroy
  has_many :referencing_histories, through: :history_histories

  has_many :inverse_history_histories, class_name: "HistoryHistory", foreign_key: "referencing_history_id"
  has_many :referenced_histories, through: :inverse_history_histories, source: :history

  def self.fetch_list_from(id, count)
    where(arel_table[:id].gteq(id)).take(count)
  end

  def self.find_by_assigned_user_id(user_id)
    ids = []
    HistoryUser.where(assignee_id: user_id).find_each do |h_user|
      ids.push(h_user.assigned_history_id)
    end
    History.find(ids)
  end
end
