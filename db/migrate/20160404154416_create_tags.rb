class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag, :null => :false
      t.string :version, :null => :false
      t.boolean :custom, :null => :false
      t.boolean :abstract, :null => :false
      t.string :datatype
      t.string :iord, :null => :false
      t.string :crdr
      t.text :tlabel
      t.text :doc
      t.timestamps null: false
    end
  end
end
