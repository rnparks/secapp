class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag, null: false
      t.string :v, null: false
      t.boolean :custom
      t.boolean :abstract
      t.string :datatype
      t.string :iord
      t.string :crdr
      t.text :tlabel
      t.text :doc
    end
  end
end
