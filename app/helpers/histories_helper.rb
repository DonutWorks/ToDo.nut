module HistoriesHelper
  # @project need to replace to current_project?
  def replace_todo_reference(reference)
    #found = Todo.find_by_id(reference[1..-1])
    
    found = Todo.where(:project_id=>@project.id, :ptodo_id=>reference[1..-1]).first
    if found
      link_to "#{found.title}(#{reference})", project_todo_path(@project, found)
    else
      reference
    end
  end

  def replace_history_reference(reference)
    #found = History.find_by_id(reference[1..-1])
    found = History.where(:project_id => @project.id).where(:phistory_id=>reference[1..-1]).first
    if found
      link_to "#{found.title}(#{reference})", project_history_path(@project, found)
    else
      reference
    end
  end

  def replace_user_reference(reference)
    found = User.find_by_nickname(reference[1..-1])
    if found
      link_to reference, show_user_path(found)
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
