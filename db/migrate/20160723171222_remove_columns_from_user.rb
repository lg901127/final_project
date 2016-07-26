class RemoveColumnsFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :uid, :string
    remove_column :users, :provider, :string
    remove_column :users, :fitbit_token, :string
    remove_column :users, :fitbit_raw_data, :string
  end
end
