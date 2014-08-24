class UpdatePobjectId5 < ActiveRecord::Migration
  def change
    histories = History.all
    histories.each do |h|
      if h.project_id == nil
        h.destroy
      else
        arel_table = History.arel_table
        pervious_histories_count = History.where(arel_table[:id].lteq(h.id)).where(arel_table[:project_id].eq(h.project_id)).count
        h.update(:phistory_id => pervious_histories_count)
      end
    end

    todos = Todo.all
    todos.each do |t|
      if t.project_id == nil
        t.destroy
      else
        arel_table = Todo.arel_table
        pervious_todo_count = Todo.where(arel_table[:id].lteq(t.id)).where(arel_table[:project_id].eq(t.project_id)).count
        t.update(:ptodo_id => pervious_todo_count)
      end
    end
  end
end
