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

  def self.find_by_assigned_user_id(user_id)
    projects = []
    ProjectUser.where(assignee_id: user_id).find_each do |p_user|
      projects.push(Project.where(id: p_user.assigned_project_id).take(1))
    end
    projects
  end
end
