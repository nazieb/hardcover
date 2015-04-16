class JenkinsBuild
  attr_accessor :branch
  attr_accessor :sha1

  def initialize(params=nil)
    if params
      from_json(params)
    end
  end

  def self.url(service_id)
    "#{APP_CONFIG['jenkins_base_url']}/job/#{service_id}/api/json"
  end

  private

  def from_json(params)
    actions = params[:actions]
    branch = get_branch(actions)
    unless branch.empty?
      ref = branch[:name]
      @sha1 = branch[:SHA1]
      if ref
        @branch = parse_branch(ref)
      end
    end
  end

  def parse_branch(ref_name)
    comps = ref_name.split("/") # e.g. origin/master
    if comps.count > 1
      comps.shift # drop origin
    end
    comps.join("/")
  end

  def get_branch(actions)
    branch = Hash.new
    actions.each do |action|
      if action.kind_of?(Hash) && git_info = action[:lastBuiltRevision]
        branch = git_info[:branch].first
      end
    end
    branch
  end
end
