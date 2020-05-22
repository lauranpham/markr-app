class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.integer :count
      t.float :mean
      t.float :stddev
      t.float :min
      t.float :max
      t.float :p25
      t.float :p50
      t.float :p75
      t.integer :available_marks

      t.timestamps
    end
  end
end
