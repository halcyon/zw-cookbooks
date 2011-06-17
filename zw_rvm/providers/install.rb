action :create do
  ruby_block "install ruby" do
    block do
      requrie 'rubygems'
      require 'rvm'

      requested = new_resource.ruby_string

      current=RVM::Environment.current
      rvm_strings = current.list_strings()
      install = requested.select { |request|
        rvm_strings.select
        { |rvm|
          ! rvm.scan(request).empty?
        }.empty?
      }

      log install

    end
    action :create
  end
end
