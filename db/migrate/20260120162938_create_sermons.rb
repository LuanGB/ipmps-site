class CreateSermons < ActiveRecord::Migration[8.0]
  def change
    create_table :sermons do |t|
      t.string :title
      t.string :description
      t.string :link

      t.timestamps
    end
  end
end
