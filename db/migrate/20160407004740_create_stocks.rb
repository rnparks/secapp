class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks, id: false do |t|
    	t.integer :cik, unique: true, null: false, references: :subs
    	t.string :ticker, unique: true
    	t.string :name
    	t.string :exchange
    	t.string :sic
    	t.string :business
    	t.string :incorporated
    	t.string :irs
    end
    add_index :stocks, :cik
  end
end
