class ChangeCharsetToUtf8 < ActiveRecord::Migration
 
  def change
    db_name = ActiveRecord::Base.connection.current_database
    execute <<-SQL
      ALTER DATABASE #{db_name} CHARACTER SET utf8 COLLATE utf8_general_ci;
    SQL
  end
end
