class SetHistoryCounter < ActiveRecord::Migration
  #local class for migration
  class Project < ActiveRecord::Base  
    has_many :histories
  end
  

  def up
    projects = Project.all
    projects.each do |p|
      
      p.update(:phistory_counter => p.histories.count)
    
    end
  end
  def down
    projects = Project.all
    projects.each do |p|
      
      p.update(:phistory_counter => 0)
    
    end
    
  end
end
