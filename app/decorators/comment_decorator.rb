class CommentDecorator < BaseDecorator
  decorates_association :user

  def contents
    attach_reference_link(object.contents, object.history.project)
  end

end