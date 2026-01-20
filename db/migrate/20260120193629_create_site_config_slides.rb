class CreateSiteConfigSlides < ActiveRecord::Migration[8.0]
  def change
    create_table :site_config_slides do |t|
      t.string :title
      t.string :subtitle
      t.string :content
      t.references :site_config, null: false, foreign_key: true

      t.timestamps
    end
  end
end
