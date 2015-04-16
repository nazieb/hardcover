class RemoveUserReposTable < ActiveRecord::Migration
  def change
    drop_table :user_repos
  end
end
