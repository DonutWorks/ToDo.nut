class BaseDecorator < Draper::Decorator
  decorates_finders
  delegate_all
  
	include Rails.application.routes.url_helpers

  def attach_reference_link(content, project)
    ReferenceCheck::ForUser.replace!(project, content) do |user, match|
      h.link_to match, show_user_path(user)
    end
    ReferenceCheck::ForHistory.replace!(project, content) do |history, match|
      h.link_to "#{history.title}(#{match})", project_history_path(project.user, project, history)
    end
    ReferenceCheck::ForTodo.replace!(project, content) do |todo, match|
      h.link_to "#{todo.title}(#{match})", project_todo_path(project.user, project, todo)
    end
    content
  end

end