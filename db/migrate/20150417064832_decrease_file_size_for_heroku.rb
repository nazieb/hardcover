class DecreaseFileSizeForHeroku < ActiveRecord::Migration
  def change
    change_column :source_files, :source, :text, :limit => 512000000
  end
end
