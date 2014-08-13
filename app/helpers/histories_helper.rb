module HistoriesHelper
  ReferenceMatchStrategy = Struct.new(:pattern, :model, :find_method)
  REFERENCE_MATCHES_STRATEGIES = [
    ReferenceMatchStrategy.new(/\B&(\d+)\b/, Todo, :find_by_id),
    ReferenceMatchStrategy.new(/\B#(\d+)\b/, History, :find_by_id),
    ReferenceMatchStrategy.new(/\B@([^\s]+)\b/, User, :find_by_nickname)
  ]
  def attach_reference_link(content)
    REFERENCE_MATCHES_STRATEGIES.each do |strategy|
      content.gsub!(strategy.pattern) do |match|
        referenced = strategy.model.send(strategy.find_method, $1)
        if referenced

          # link_to match, [Project.find(referenced.project_id), referenced]

          if strategy.find_method == :find_by_id
          #How to make this line clearer...
            link_to match, [Project.find(referenced.project_id), referenced]
          else 
            link_to match, project_members_path(Project.find(params[:project_id]),referenced)
          end

        else
          match
        end
      end
    end
    content
  end
end
