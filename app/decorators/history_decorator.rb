class HistoryDecorator < BaseDecorator

  def description
    attach_reference_link(object.description, object.project)
  end

  def title
    attach_reference_link(object.title, object.project)
  end

  def reference_link
    h.link_to "##{object.id}: #{object.title}", project_history_path(object.project, object)
  end
  
end