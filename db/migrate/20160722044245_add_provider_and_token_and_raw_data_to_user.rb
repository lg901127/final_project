class AddProviderAndTokenAndRawDataToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :fitbit_token, :string
    add_column :users, :fitbit_raw_data, :text
  end
end
