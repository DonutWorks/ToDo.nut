module HistoriesHelper
  # @project need to replace to current_project?
  def attach_reference_link(content)
    ReferenceCheck::ForUser.replace!(content) do |user, match|
      link_to match, show_user_path(user)
    end
    ReferenceCheck::ForHistory.replace!(content) do |history, match|
      link_to "#{history.title}(#{match})", project_history_path(@project, history)
    end
    ReferenceCheck::ForTodo.replace!(content) do |todo, match|
      link_to "#{todo.title}(#{match})", project_todo_path(@project, todo)
    end
    content
  end
end
