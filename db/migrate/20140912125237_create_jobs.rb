class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :service_job_id
      t.string :service_name

      t.timestamps
    end
  end
end
