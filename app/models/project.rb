class Project < ActiveRecord::Base
	has_many :project_users, foreign_key: :assigned_project_id
  has_many :assignees, through: :project_users
	
	belongs_to :user
  has_many :todos
  has_many :histories

  def fetch_members_by_nickname(nickname, count)
    members = assignees.arel_table
    
    assignees.where(members[:nickname].matches("%#{nickname}%")).take(count)
  end



end
