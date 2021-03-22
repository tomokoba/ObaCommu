class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.references :user, null: false
      t.references :room, null: false
      t.string :message, null: false
      t.timestamps
    end
  end
end
