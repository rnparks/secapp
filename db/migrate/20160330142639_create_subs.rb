      class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs, id: false do |t|
      t.string :adsh, unique: true
      t.integer :cik
      t.string :name
      t.integer :sic
      t.string :countryba
      t.string :stprba
      t.string :cityba
      t.string :zipba
      t.string :bas1
      t.string :bas2
      t.string :baph
      t.string :countryma
      t.string :stprma
      t.string :cityma
      t.string :zipma
      t.string :mas1
      t.string :mas2
      t.string :countryinc
      t.string :stprinc
      t.integer :ein
      t.string :former
      # updated column changed to changedd inorder to avoid ActiveRecord namespacing conflict
      t.string :changedd
      t.string :afs
      t.boolean :wksi
      t.string :fye
      t.string :form
      t.date :period
      t.integer :fy
      t.string :fp
      t.date :filed
      t.datetime :accepted
      t.boolean :prevrpt
      t.boolean :detail
      t.string :instance
      t.integer :nciks
      t.string :aciks
      t.timestamps null: false
    end
    add_index :subs, :adsh
  end
end
