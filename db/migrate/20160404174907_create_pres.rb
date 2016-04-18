class CreatePres < ActiveRecord::Migration
  def change
    create_table :pres do |t|
      t.string :adsh, null: false, references: :nums
      t.integer :report, null: false
      t.integer :line, null: false
      t.string :stmt
      t.boolean :inpth
      t.string :rfile
      t.string :tag, references: :nums
      t.string :version, references: :nums
      t.string :plabel
      t.timestamps null: false
    end
  end
end
