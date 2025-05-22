class CreateVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :visits do |t|
      t.string :page_path, null: false
      t.datetime :last_visited_at
      t.integer :visit_count, default: 0

      t.timestamps
    end

    add_index :visits, :page_path, unique: true
  end
end 