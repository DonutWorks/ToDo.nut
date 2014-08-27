class CommentDecorator < BaseDecorator

  def contents
    attach_reference_link(object.contents, object.history.project)
  end

end