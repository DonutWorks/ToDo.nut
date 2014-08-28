class BaseDecorator < Draper::Decorator
  decorates_finders
  delegate_all
  
	include Rails.application.routes.url_helpers

  def attach_reference_link(content, project)
    ReferenceCheck::ForUser.replace!(project, content) do |user, match|
      h.link_to match, show_user_path(user)
    end
    ReferenceCheck::ForHistory.replace!(project, content) do |history, match|
      h.link_to "#{history.title}(#{match})", project_history_path(project.project_owner, project.title, history.phistory_id)
    end
    ReferenceCheck::ForTodo.replace!(project, content) do |todo, match|
      h.link_to "#{todo.title}(#{match})", project_todo_path(project.project_owner, project.title, todo.ptodo_id)
    end
    content
  end

end