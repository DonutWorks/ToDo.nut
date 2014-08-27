class TodoVisualizationSerializer < ActiveModel::Serializer

  attributes :project_creator_nickname, :project_title, :title, :color, :duedate, :ptodo_id, :total
  has_many :histories, serializer: HistoryVisualizationSerializer

  
  def project_title
    object.project.title
  end
  def project_creator_nickname
    object.project.user.nickname
  end
  
  def histories
    arel_table = History.arel_table
    object.histories.where(arel_table[:evented_at].gteq(Time.now.to_date - 11.days))
    
  end

  def total
    arel_table = History.arel_table
    object.histories.where(arel_table[:evented_at].gteq(Time.now.to_date - 11.days)).length * 5

  end

  def duedate
    object.duedate.strftime('%m/%d')
  end

end
