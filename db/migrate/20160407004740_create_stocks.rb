class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks, id: false do |t|
      t.belongs_to :subs, index: true
    	t.string :cik, unique: true
    	t.string :ticker, unique: true
    	t.string :name
    	t.string :exchange
    	t.string :sic
    	t.string :business
    	t.string :incorporated
    	t.string :irs
      t.timestamps null: false
    end
    add_index :stocks, :name
  end
end
