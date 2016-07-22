class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :desctription

      t.timestamps null: false
    end
  end
end
