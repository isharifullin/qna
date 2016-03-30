class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :question_id
      t.integer :user_id

      t.timestamps null: false
    end
     add_index :subscriptions, [:question_id, :user_id], unique: true
  end
end
