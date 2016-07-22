class ChangeTableName < ActiveRecord::Migration
  def change
    rename_column :items, :desctription, :description
  end
end
