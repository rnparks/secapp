class CreateFilers < ActiveRecord::Migration
  def change
    create_table :filers, id: false do |t|

      t.integer :cik, unique: true, null: false
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
      t.string :symbol
      # updated column changed to changedd inorder to avoid ActiveRecord namespacing conflict
      t.string :changedd
      t.string :afs
      t.boolean :wksi
      t.string :fye
      t.date :period
      t.string :displayname
    	t.string :exchange
    	t.string :sic
    	t.string :business
    	t.string :incorporated
    	t.string :irs
    end
    add_index :filers, :cik, :unique => true
  end
end
