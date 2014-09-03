class HistoryDecorator < BaseDecorator
  decorates_association :user
  decorates_association :comments
  decorates_association :assignees
  
  decorates_association :referenced_histories

  def description
    attach_reference_link(object.description, object.project)
  end

  def title
    attach_reference_link(object.title, object.project)
  end

  def reference_link
    h.link_to "##{object.phistory_id}: #{object.title}", project_history_path(object.project.user, object.project, object)
  end
  
end