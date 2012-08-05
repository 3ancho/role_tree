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

    # Read roles of a parent role
    def read_role(p_role_name)
      role_list = []
      start = false
      p_role_name += ".rb" unless p_role_name =~ /.+\.rb/
      file_full_path = File.join(File.expand_path(Chef::Config[:role_path]), p_role_name)
      File.open(file_full_path, 'r+') do |f|
        lines = f.readlines
        lines.each do |line|
          start = true if line.include? "run_list" 

          if start
            next if line =~ /.+#.+["']/
            if line =~ /["']role\[(.+)\]["']/
              role_list << $1 
            elsif line =~ /["']recipe\[(.+)\]["']/
              role_list << "*" + $1 
            elsif line =~ /\"(.+)\"/
              role_list << "*" + $1 
            end
          end

          break if line.include? ")" and start == true  
        end
      end
      role_list
    end

    # Read recipes of a role
    def read_recipe(p_role_name) 
      recipe_list = []
      start = false
      file_full_path = File.join(File.expand_path(Chef::Config[:role_path]), p_role_name)
      File.open(file_full_path, 'r+') do |f|
        lines = f.readlines
        lines.each do |line|
          start = true if line.include? "run_list" 

          if start
            next if line =~ /.+#.+["']/
          end

          break if line.include? ")" and start == true  
        end
      end
      recipe_list
    end

    def tree(roles=[], n=1)
      roles.each do |r|
        if r.include? "*"
          puts "  " * n + r
          next
        end
        roles = read_role(r)
        if roles.nil?
          return
        else
          puts "  " * n + r
          tree(roles, n+1)
        end
      end
    end

    def run
      self.config = Chef::Config.merge!(config)

      if config[:role]
        puts "read a single role"
        tree([config[:role]])
      else
        puts "read all role"
        role_path = File.expand_path(Chef::Config[:role_path])
        loaded_roles = loader.find_all_objects(role_path)
        tree(loaded_roles)
      end
      
      role_path = File.expand_path(Chef::Config[:role_path])

      loaded_roles = loader.find_all_objects(role_path)

      loaded_roles.each do |role|
      end

      puts 'end of tree'
    end #run end
  end #class end
end #module end
