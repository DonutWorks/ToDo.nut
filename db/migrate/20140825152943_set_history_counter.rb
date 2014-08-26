class SetHistoryCounter < ActiveRecord::Migration
  def up
    projects = Project.all
    projects.each do |p|
      
      p.update(:history_counter => p.histories.count)
    
    end
  end
  def down
    projects = Project.all
    projects.each do |p|
      
      p.update(:history_counter => 0)
    
    end
  end
end
