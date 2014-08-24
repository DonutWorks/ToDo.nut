module ReferenceCheck

  # Extending ReferenceChecker
  # required: pattern, find_method
  #
  # Usage Examples
  # ReferenceCheck::ForUser.references(content)
  # => return referenced users (model instance) in content.
  #
  # ReferenceCheck::ForUser.replace(content) { |user| user.nickname + "!" }
  # => return content replaced @nickname to #{nickname}!
  #
  # ReferenceCheck::ForUser.pattern
  # => return regex for matching user reference.
  #
  # ReferenceCheck::ForUser.find_method
  # => return predicate method for finding referee.

  module ReferenceChecker
    def self.extended(base)
      base.define_singleton_method(:replace!) do |content, &block|
        content.gsub!(pattern) do |match|
          found = find_method($1)
          if found
            block.call(found, match)
          else
            match
          end
        end
      end

      base.define_singleton_method(:replace) do |content, &block|
        replace!(content.dup, &block)
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
    extend ReferenceChecker
    pattern /\B@([^\s]+)\b/
    find_method lambda { |term| User.find_by_nickname(term) }
  end

  class ForHistory
    extend ReferenceChecker
    pattern /\B#(\d+)\b/
    find_method lambda { |term| History.find_by_id(term) }
  end

  class ForTodo
    extend ReferenceChecker
    pattern /\B@([^\s]+)\b/
    find_method lambda { |term| Todo.find_by_id(term) }
  end
end