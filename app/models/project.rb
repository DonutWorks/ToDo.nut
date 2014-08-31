class Project < ActiveRecord::Base
	has_many :project_users, foreign_key: :assigned_project_id
  has_many :assignees, through: :project_users
	
	belongs_to :user
  has_many :todos
  has_many :histories

  delegate :nickname, to: :user, allow_nil: true
  def project_owner
    self.nickname
  end

  def to_param
    title
  end

  def fetch_members_by_nickname(nickname, count)
    members = assignees.arel_table
    assignees.where(members[:nickname].matches("%#{nickname}%")).take(count)
  end

  def assign_users_with_ids!(user_ids)
    assignees.destroy_all
    user_ids.each do |user_id|
      project_users.build(assignee_id: user_id)
    end unless user_ids.nil?
  end
end
