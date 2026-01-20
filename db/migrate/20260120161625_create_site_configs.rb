class CreateSiteConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :site_configs do |t|
      t.boolean :active
      t.integer :last_updated_by
      t.jsonb :site_data, default: {}, null: false

      t.timestamps
    end
  end
end
