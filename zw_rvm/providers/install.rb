action :create do
  ruby_block "install ruby" do
    block do
      requrie 'rubygems'
      require 'rvm'

      current=RVM::Environment.current

      rvm_strings = current.list_strings()
      puts "rvm_strings "
      p rvm_strings

      puts "to be installed: "
      p requested.select { |request|
        rvm_strings.select
        { |rvm|
          ! rvm.scan(request).empty?
        }.empty?
      }

    end
    action :create
  end
end
