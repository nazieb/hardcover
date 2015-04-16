class MigrateAllJobCoverages < ActiveRecord::Migration
  def up
    Job.all.each { |job| job.set_coverage }
  end
end
