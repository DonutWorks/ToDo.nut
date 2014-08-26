class ReplaceOldReferencetoNew < ActiveRecord::Migration
  def up
    histories = History.all
    histories.each do |h|
      
      content = h.description.dup
      puts "old content : #{content}"
      
      content.gsub!(/\B&(\d+)\b/) do |match|
        found = Todo.find_by_id(match[1..-1])
        if found
          "&" + found.ptodo_id.to_s
        else
          match 
        end
      end


      content.gsub!(/\B#(\d+)\b/) do |match|
        found = History.find_by_id(match[1..-1])
        if found
          "#" + found.phistory_id.to_s
        else
          match
        end
      end
      
      
      h.update!(:description => content)
      puts "new content : #{h.description}"
    end
    
  end
  def down
    histories = History.all
    histories.each do |h|
      content = h.description.dup

      puts "old content : #{content}"
      
      content.gsub!(/\B&(\d+)\b/) do |match|
        found = h.project.todos.where(:ptodo_id => match[1..-1]).first

        if found
          "&" + found.id.to_s
        else
          match 
        end
      end


      content.gsub!(/\B#(\d+)\b/) do |match|
        found = h.project.histories.where(:phistory_id => match[1..-1]).first
        
        if found
          "#" + found.id.to_s
        else
          match
        end
      end
      
      
      h.update!(:description => content)
      puts "new content : #{h.description}"
    end
  end
end
