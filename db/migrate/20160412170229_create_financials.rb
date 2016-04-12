class CreateFinancials < ActiveRecord::Migration
  def change
    create_table :financials do |t|
      t.timestamps null: false
    end
  end
end
