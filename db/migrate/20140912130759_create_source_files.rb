class CreateSourceFiles < ActiveRecord::Migration
  def change
    create_table :source_files do |t|
      t.string :name
      t.text :source
      t.text :coverage
      t.belongs_to :job

      t.timestamps
    end
  end
end
