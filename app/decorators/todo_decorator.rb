class TodoDecorator < BaseDecorator
  decorates_association :user
  decorates_association :histories

  def title
    attach_reference_link(object.title, object.project)
  end
  
end