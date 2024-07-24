class CreateResults < ActiveRecord::Migration[7.1]
  def change
    create_table :results do |t|
      t.string :subject
      t.datetime :timestamp
      t.float :marks

      t.timestamps
    end
  end
end
