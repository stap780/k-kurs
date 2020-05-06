class CreateKurs < ActiveRecord::Migration[5.0]
  def change
    create_table :kurs do |t|
      t.datetime :date
      t.string :gbp
      t.string :byn
      t.string :usd
      t.string :eur
      t.string :kzt
      t.string :cny
      t.string :uah
      t.string :chf
      t.string :jpy

      t.timestamps
    end
  end
end
