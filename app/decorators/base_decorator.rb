class BaseDecorator < Draper::Decorator

	include Rails.application.routes.url_helpers

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