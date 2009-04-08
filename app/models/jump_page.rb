class JumpPage < Page
  attr_accessor :last_url, :last_title

  def config
    debugger
    config = self.render_part(:config)
    (config.nil? || config.empty?) ? {:exclude => []} : YAML::load(config).symbolize_keys
  end
end