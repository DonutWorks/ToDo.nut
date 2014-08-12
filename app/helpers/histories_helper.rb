module HistoriesHelper
  ReferenceMatchStrategy = Struct.new(:pattern, :model, :find_method)
  REFERENCE_MATCHES_STRATEGIES = [
    ReferenceMatchStrategy.new(/\B&(\d+)\b/, Todo, :find_by_id),
    ReferenceMatchStrategy.new(/\B#(\d+)\b/, History, :find_by_id),
  ]
  def attach_reference_link(content)
    REFERENCE_MATCHES_STRATEGIES.each do |strategy|
      content.gsub!(strategy.pattern) do |match|
        referenced = strategy.model.send(strategy.find_method, $1)
        if referenced
          #How to make this line clearer...
          link_to match, [Project.find(referenced.project_id), referenced]
        else
          match
        end
      end
    end
    content
  end
end
