class Comment < ActiveRecord::Base
  belongs_to :task, polymorphic: true
  belongs_to :item, polymorphic: true
end


class RenameCommentTasksToItems < ActiveRecord::Migration

  def up
    add_reference :comments, :item, index: true, polymorphic: true

    Comment.find_each do |comment|
      # I have comments without task reference in my DB, they cause save! to fail
      # (dependent: destroy was missing on the has_many :comments association).
      next unless comment.task 
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
