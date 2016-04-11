class CreateSics < ActiveRecord::Migration
  def change
    create_table :sics do |t|
    	t.integer :sic, null: false, references: :subs
    	t.string :sic_descrip
    	t.integer :naics
    	t.string :naics_descrip
      t.timestamps null: false
    end
  end
end
