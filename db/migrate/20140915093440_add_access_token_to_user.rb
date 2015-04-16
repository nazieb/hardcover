class AddAccessTokenToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :access_token
    end
  end
end
