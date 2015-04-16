class ChangeTextLimitOfSourceFiles < ActiveRecord::Migration
  def change
    change_column :source_files, :source, :text, :limit => 4294967295
  end
end