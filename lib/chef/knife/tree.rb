require 'chef/knife'
require 'chef/role'

module RoleTree
  class Tree < Chef::Knife

    deps do
      require 'chef/role'
      require 'chef/knife/core/object_loader'
    end

    banner "knife role tree"

    option :recipe1,
      :short => "-rrr",
      :long => "--recipe11",
      :boolean => true,
      :description => "show recipes of a role"

    def run

      puts "end of tree"

    end #run end
  end #class end
end #module end
