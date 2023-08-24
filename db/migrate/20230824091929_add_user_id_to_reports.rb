class AddUserIdToReports < ActiveRecord::Migration[7.0]

  def change
    add_reference :reports,:users,foreign_key: true
    change_column :reports, :user_id,:integer,null: false
  end
end
