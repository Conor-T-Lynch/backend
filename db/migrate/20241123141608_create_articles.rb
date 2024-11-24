class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :author
      t.text :content
      t.datetime :publish_date

      t.timestamps
    end
  end
end
