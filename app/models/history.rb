class History < ActiveRecord::Base

  before_create :phistory_counter_increment
  before_save :associate_histories!, :associate_todos!
  after_save :send_notifications!
  
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


  include PublicActivity::Model
  tracked :except => :destroy
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  def self.fetch_list_from(phistory_id, count)
    where(arel_table[:phistory_id].gteq(phistory_id)).take(count)
  end

  def to_param
    phistory_id
  end

  def attach_images!(images)
    self.images.destroy_all
    images.each do |image|
      images.build(image: image)
    end unless images.nil?
  end

  def assign_users_with_ids!(user_ids)
    assignees.destroy_all
    user_ids.each do |user_id|
      history_users.build(assignee_id: user_id)
    end unless user_ids.nil?
  end

  private
    def phistory_counter_increment
      self.phistory_id = self.project.phistory_counter + 1
      self.project.update(:phistory_counter => self.project.phistory_counter + 1)
    end

    def associate_histories!
      referenced_histories = ReferenceCheck::ForHistory.references(project, description)
      referencing_histories.destroy_all
      referenced_histories.each do |history|
        history_histories.build(referencing_history_id: history.id)
      end
    end

    def associate_todos!
      referenced_todos = ReferenceCheck::ForTodo.references(project, description)
      todos.destroy_all
      referenced_todos.each do |todo|
        history_todos.build(todo_id: todo.id)
      end
    end

    def send_notifications!
      mentioned_users = description.scan(/\B@([^\s]+)\b/).flatten!.to_a
      mentioned_users.map! { |nickname| User.find_by_nickname(nickname) }
      mentioned_users.each do |user|
        create_activity(action: 'mention', recipient: user, owner: self.user)
      end
    end
end
