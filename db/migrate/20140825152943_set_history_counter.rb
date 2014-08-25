class SetHistoryCounter < ActiveRecord::Migration
  def change
    projects = Project.all
    projects.each do |p|
      
      p.update(:history_counter => p.histories.count)
    
    end
  end
end
