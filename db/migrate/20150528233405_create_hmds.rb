class CreateHmds < ActiveRecord::Migration
  def change
    create_table :hmds do |t|
      t.string :name, null: false, limit: 512
      t.string :company, null: false, limit: 512
      t.string :state, null: false, limit: 64
      t.string :image_url, null: false, limit: 512
      t.datetime :announced_at, null: false

      t.timestamps null: false
    end
  end
end
