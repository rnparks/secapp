class CreateSubs < ActiveRecord::Migration
  def change
    create_table :subs, id: false do |t|
      t.string :adsh, :unique => true
      t.integer :cik
      t.string :name, :null => :false
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
      t.boolean :wksi, :null => :false
      t.string :fye, :null => :false
      t.string :form, :null => :false
      t.date :period, :null => :false
      t.integer :fy, :null => :false
      t.string :fp, :null => :false
      t.date :filed, :null => :false
      t.datetime :accepted, :null => :false
      t.boolean :prevrpt, :null => :false
      t.boolean :detail, :null => :false
      t.string :instance, :null => :false
      t.integer :nciks, :null => :false
      t.string :aciks
    end
  end
end
