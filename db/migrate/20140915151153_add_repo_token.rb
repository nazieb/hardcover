class AddRepoToken < ActiveRecord::Migration
  def change
    change_table :jobs do |t|
      t.string :repo_token
    end
  end
end
