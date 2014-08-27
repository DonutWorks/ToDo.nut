class CommentDecorator < BaseDecorator

  def contents
     attach_reference_link(object.contents)
  end

  def replace_todo_reference(reference)
    found = Todo.find_by_id(reference[1..-1])
    if found
      h.link_to "#{found.title}(#{reference})", project_todo_path(object.history.project, found)
    else
      reference
    end
  end

  def replace_history_reference(reference)
    found = History.find_by_id(reference[1..-1])
    if found
      h.link_to "#{found.title}(#{reference})", project_history_path(object.history.project, found)
    else
      reference
    end
  end

  def replace_user_reference(reference)
    found = User.find_by_nickname(reference[1..-1])
    if found
      h.link_to reference, show_user_path(found)
    else
      reference
    end
  end
  
end