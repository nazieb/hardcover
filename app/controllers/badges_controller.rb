class BadgesController < ApplicationController
  def show
    percentage = last_job_percentage
    if percentage
      @badge = Badges::Coverage.new(percentage)
    else
      @badge = Badges::CoveragePending.new
    end

    respond_to do |format|
      format.html
      format.svg do
        case params[:style]
        when 'flat'
          render :flat
        when 'plastic'
          render :plastic
        else
          render :flat_squared
        end
      end
    end
  end

  private

  def last_job_percentage
    if params[:source_id].present?
      result = SourceFile.find(params[:source_id])
    elsif params[:job_id].present?
      result = Job.find(params[:job_id])
    else
      result = Repo.find_by!(login: params[:org], name: params[:repo_name]).last_job
    end

    result.try(:coverage_percentage)
  end
end
