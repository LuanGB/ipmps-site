class CreateSiteConfigVerses < ActiveRecord::Migration[8.0]
  def change
    create_table :site_config_verses do |t|
      t.string :content
      t.string :reference
      t.references :site_config, null: false, foreign_key: true

      t.timestamps
    end
  end
end
