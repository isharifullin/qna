class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :commentable, index: true, polymorphic: true
      t.string :body

      t.timestamps null: false
    end
  end
end
