class HistoryVisualizationSerializer < ActiveModel::Serializer
  attributes :when, :weight

  def when
    (object.evented_at.to_date - Time.now.to_date).to_i
  end
  def weight
    5
  end

end
