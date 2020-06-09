class CreateRailsAdminSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :rails_admin_settings do |t|
      t.boolean :enabled, default: true
      t.string :kind, null: false, default: 'string'
      t.string :ns, default: 'main'
      t.string :key, null: false
      if Object.const_defined?('Geocoder')
        t.float :latitude
        t.float :longitude
      end
      t.text :raw
      t.string :label
      if defined?(Paperclip)
        t.attachment :file
      elsif defined?(CarrierWave)
        t.string :file
      elsif defined?(Shrine)
        t.text :file_data

      end
      t.timestamps
    end

    add_index :rails_admin_settings, :key
    add_index :rails_admin_settings, [:ns, :key], unique: true
  end
end

