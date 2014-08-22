module ReferenceCheck
  module ReferenceCheckerTrait
    def self.extended(base)
      base.define_singleton_method(:replace) do |content, &block|
        content.gsub(pattern) do |match|
          found = find_method($1)
          block.call(found)
        end
      end

      base.define_singleton_method(:references) do |content|
        referenced = content.scan(pattern)
        referenced.flatten!.map! do |term|
          find_method(term)
        end if !referenced.empty?
      end
    end

    def pattern(pattern)
      self.define_singleton_method(:pattern) do
        pattern
      end
    end

    def find_method(method)
      self.define_singleton_method(:find_method) do |term|
        method.call(term)
      end
    end
  end

  class ForUser
    extend ReferenceCheckerTrait
    pattern /\B@([^\s]+)\b/
    find_method lambda { |term| User.find_by_nickname(term) }
  end

  class ForHistory
    extend ReferenceCheckerTrait
    pattern /\B#(\d+)\b/
    find_method lambda { |term| History.find_by_id(term) }
  end

  class ForTodo
    extend ReferenceCheckerTrait
    pattern /\B@([^\s]+)\b/
    find_method lambda { |term| Todo.find_by_id(term) }
  end
end