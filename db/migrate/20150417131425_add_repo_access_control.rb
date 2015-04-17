class AddRepoAccessControl < ActiveRecord::Migration
  def change
    change_table :repos do |t|
      t.boolean  "is_private"
    end
  end
end
