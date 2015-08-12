class CreateStoredBindings < ActiveRecord::Migration
  def change
    create_table :stored_bindings do |t|
      t.text :data

      t.timestamps null: false
    end
  end
end
