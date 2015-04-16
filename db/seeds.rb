if Rails.env == "development"
  # Create Repo
  repo_json = JSON.parse(File.read("spec/fixtures/gh_repo.json"), :symbolize_names => true)
  repo_json.each do |params|
    repo = Repo.from_github(params)
    repo.save

    # Create a few Jobs for octocat
    if (repo.id == 1296269)
      ["master", "feature/1", "feature/2"].each_with_index do |branch, index|
        json_file = File.read("spec/fixtures/job#{index+1}.json")
        json = JSON.parse(json_file)
        hash = json.to_hash
        hash[:repo_token] = repo.repo_token
        hash['source_files_attributes'] = hash.delete('source_files')
        job = Job.new(hash)
        job.branch = branch
        job.save
      end
    end
  end
end
