class History < ActiveRecord::Base


  before_create :phistory_counter_increment
  
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

  validate :user, presence: true
  validate :project, presence: true
  validate :title, presence: true

  include PublicActivity::Model
  tracked :except => :destroy
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy

  def self.fetch_list_from(id, count)
    where(arel_table[:id].gteq(id)).take(count)
  end

  private
    def phistory_counter_increment
      self.phistory_id = self.project.phistory_counter + 1
      self.project.update(:phistory_counter => self.project.phistory_counter + 1)
      puts 'increment phistory counter'
    end

end
