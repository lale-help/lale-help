class Comment < ActiveRecord::Base
  belongs_to :task, polymorphic: true
  belongs_to :item, polymorphic: true
end


class RenameCommentTasksToItems < ActiveRecord::Migration

  def up
    add_reference :comments, :item, index: true, polymorphic: true

    Comment.all.each do |comment|
      comment.item = comment.task
      comment.save!
    end

    change_column_null :comments, :task_id, true, nil
    change_column_null :comments, :task_type, true, nil
  end

  def down
    remove_reference :comments, :item, polymorphic: true
    change_column_null :comments, :task_id, false
    change_column_null :comments, :task_type, false
  end

end
