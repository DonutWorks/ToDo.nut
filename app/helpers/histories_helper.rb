module HistoriesHelper
  # @project need to replace to current_project?
  def replace_todo_reference(reference)
    found = Todo.find_by_id(reference[1..-1])
    if found
      link_to "#{found.title}(#{reference})", project_todo_path(@project, found)
    else
      reference
    end
  end

  def replace_history_reference(reference)
    found = History.find_by_id(reference[1..-1])
    if found
      link_to "#{found.title}(#{reference})", project_history_path(@project, found)
    else
      reference
    end
  end

  def replace_user_reference(reference)
    found = User.find_by_nickname(reference[1..-1])
    if found
      link_to reference, user_path(found)
    else
      reference
    end
  end

  ReferenceReplaceStrategy = Struct.new(:pattern, :replacer)
  REFERENCE_REPLACE_STRATEGIES = [
    ReferenceReplaceStrategy.new(/\B&(\d+)\b/, instance_method(:replace_todo_reference)),
    ReferenceReplaceStrategy.new(/\B#(\d+)\b/, instance_method(:replace_history_reference)),
    ReferenceReplaceStrategy.new(/\B@([^\s]+)\b/, instance_method(:replace_user_reference))
  ]
  def attach_reference_link(content)
    REFERENCE_REPLACE_STRATEGIES.each do |strategy|
      content.gsub!(strategy.pattern) do |match|
        strategy.replacer.bind(self).call(match)
      end
    end
    content
  end
end