class DecreaseFileSizeEvenMore < ActiveRecord::Migration
  def change
    change_column :source_files, :source, :text, :limit => 65536
  end
end
