class CreateRailsAdminSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :rails_admin_settings do |t|
      # SQLite's DEFAULT TRUE is read as nil by the Rails 8.0 adapter.
      t.boolean :enabled, default: 1
      t.string :kind, null: false, default: 'string'
      t.string :ns, default: 'main'
      t.string :key, null: false
      t.text :raw
      t.string :label
      t.timestamps
    end

    add_index :rails_admin_settings, :key
    add_index :rails_admin_settings, [:ns, :key], unique: true
  end
end
