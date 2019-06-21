class CreateLetters < ActiveRecord::Migration[5.1]
  def change
    create_table :letters do |t|
			t.string :name
			t.string :date
			t.integer :count, default: 0

      t.timestamps
    end
  end
end
