class AddRepoTokenToRepo < ActiveRecord::Migration
  def change
    change_table :repos do |t|
      t.string :repo_token
    end
  end
end
