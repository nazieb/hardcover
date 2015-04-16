class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :name
      t.string :full_name
      t.string :login

      t.timestamps
    end
  end
end
