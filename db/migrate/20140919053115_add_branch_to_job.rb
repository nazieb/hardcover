class AddBranchToJob < ActiveRecord::Migration
  def change
    change_table :jobs do |t|
      t.string :branch
    end
  end
end
