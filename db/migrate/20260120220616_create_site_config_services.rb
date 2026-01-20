class CreateSiteConfigServices < ActiveRecord::Migration[8.0]
  def change
    create_table :site_config_services do |t|
      t.string :title
      t.text :description
      t.string :schedule
      t.references :site_config, null: false, foreign_key: true

      t.timestamps
    end
  end
end
