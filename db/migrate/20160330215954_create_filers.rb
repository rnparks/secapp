class CreateFilers < ActiveRecord::Migration
  def change
    create_table :filers do |t|

      t.timestamps null: false
    end
  end
end
