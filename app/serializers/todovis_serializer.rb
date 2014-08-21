class TodovisSerializer < ActiveModel::Serializer
  attributes :project_id, :title, :color, :duedate, :id, :total
  has_many :histories, serializer: HistoryvisSerializer

  
  def histories
    object.histories.where('evented_at >= ?',Time.now.to_date-11)
  end

  def total
    object.histories.where('evented_at >= ?',Time.now.to_date-11).count*5
  end

  def duedate
    object.duedate.strftime('%m/%d')
  end
end
