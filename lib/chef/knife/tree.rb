require 'chef/knife'
require 'chef/role'
require 'chef/knife/core/object_loader'

module RoleTreePlugin
  class RoleTree < Chef::Knife

    deps do
      require 'chef/role'
      require 'chef/knife/core/object_loader'
    end

    banner 'knife role tree'

    option :role,
      :short => '-r ROLE',
      :long => '--role ROLE',
      :description => 'show tree of specified role'

    option :list,
      :short => '-l',
      :long => '--list',
      :description => 'show a list'

    option :recipe,
      :short => '-R',
      :long => '--recipe',
      :boolean => true,
      :description => 'include recipes of each role'

    def loader
      @loader ||= Chef::Knife::Core::ObjectLoader.new(Chef::Role, ui)
    end

    def read_role(role_name) 
      File.open(role_name, 'r+') do |f|
        lines = f.readlines
        lines.each do |line|
          if line =~ /^version\s+["'](\d+)\.(\d+)\.(\d+)["'].*$/
            major = $1
            minor = $2
            patch = $3
            current_version = "#{major}.#{minor}.#{patch}"
            available_versions = Chef::CookbookVersion.available_versions(cookbook_name)
            if available_versions.nil?
              Chef::Log.info("User added a new cookbook: #{cookbook_name}")
            end
          end
        end
      end
    end

    def run
      self.config = Chef::Config.merge!(config)
      
      role_path = "/Users/ruoran/work/chef/roles"
      Chef::Log.info(role_path)
      puts role_path

      loaded_roles = loader.find_all_objects(role_path)

      puts loaded_roles

      puts 'end of tree'
    end #run end
  end #class end
end #module end
