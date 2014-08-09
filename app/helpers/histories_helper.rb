module HistoriesHelper
  include ActionView::Helpers::UrlHelper

  ReferenceMatchStrategy = Struct.new(:pattern, :model, :find_method)
  REFERENCE_MATCHES_STRATEGIES = [
    ReferenceMatchStrategy.new(/\B&(\d+)\b/, Todo, :find_by_id),
    ReferenceMatchStrategy.new(/\B#(\d+)\b/, History, :find_by_id),
  ]
  def attach_reference_link(content)
    REFERENCE_MATCHES_STRATEGIES.each do |strategy|
      content.gsub!(strategy.pattern) { |match|
        referenced = strategy.model.send(strategy.find_method, $1)
        if referenced
          link_to match, referenced
        else
          match
        end
      }
    end
      content
  end
end
