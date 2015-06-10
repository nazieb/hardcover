class AddShaToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :sha, :string
  end
end
