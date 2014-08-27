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

  class ReferenceChecker
    def self.replace!(content)
      content.gsub!(pattern) do |match|
        found = find_method($1)
        if found
          yield found, match
        else
          match
        end
      end
    end

    def self.replace(content, &block)
      replace!(content.dup, &block)
    end

    def self.references(content)
      referenced = content.scan(pattern)
      referenced.flatten!.map! do |term|
        find_method(term)
      end if !referenced.empty?
    end

    def self.pattern(pattern)
      raise 'This method should be overriden and return the pattern.'
    end

    def self.find_method(method)
      raise 'This method should be overriden and return the find method.'
    end
  end

  class ForUser < ReferenceChecker
    def self.pattern
      /\B@([^\s]+)\b/
    end

    def self.find_method(term)
      User.find_by_nickname(term)
    end
  end

  class ForHistory < ReferenceChecker
    def self.pattern
      /\B#(\d+)\b/
    end

    def self.find_method(term)
      History.find_by_id(term)
    end
  end

  class ForTodo < ReferenceChecker
    def self.pattern
      /\B&(\d+)\b/
    end

    def self.find_method(term)
      Todo.find_by_id(term)
    end
  end
end