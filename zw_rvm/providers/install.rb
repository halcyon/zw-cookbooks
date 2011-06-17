action :create do
  ruby_block "install ruby" do
    block do
      require 'rubygems'
      require 'rvm'

      requested = new_resource.ruby_string

      current=RVM::Environment.current
      rvm_strings = current.list_strings()
      install_strings = requested.select { |request|
        rvm_strings.select { |rvm|
          ! rvm.scan(request).empty?
        }.empty?
      }

      install_strings.each() do |install|
        current.install(install)
      end

    end
    action :create
  end
end
