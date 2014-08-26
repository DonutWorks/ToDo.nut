class HistoryDecorator < Draper::Decorator

  include Rails.application.routes.url_helpers

  def description
     attach_reference_link(object.description)
  end

  def reference_link
    h.link_to "##{object.id}: #{object.title}", project_history_path(object.project, object)
  end


  def replace_todo_reference(reference)
    found = Todo.find_by_id(reference[1..-1])
    if found
      h.link_to "#{found.title}(#{reference})", project_todo_path(object.project, found)
    else
      reference
    end
  end

  def replace_history_reference(reference)
    found = History.find_by_id(reference[1..-1])
    if found
      h.link_to "#{found.title}(#{reference})", project_history_path(object.project, found)
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


  REFERENCE_REPLACE_STRATEGIES = [
    {pattern: /\B&(\d+)\b/, replacer: :replace_todo_reference},
    {pattern: /\B#(\d+)\b/, replacer: :replace_history_reference},
    {pattern: /\B@([^\s]+)\b/, replacer: :replace_user_reference},
  ]

  def attach_reference_link(content)
    REFERENCE_REPLACE_STRATEGIES.each do |strategy|
      content.gsub!(strategy[:pattern]) do |match|
        self.send(strategy[:replacer], match)
      end
    end
    content
  end
  
end