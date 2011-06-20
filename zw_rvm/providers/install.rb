action :create do
  ruby_block "install ruby" do
    block do
      require 'rubygems'
      require 'rvm'

      ruby_string = new_resource.ruby_string
      gemset = new_resource.gemset

      puts gemset.class

      current=RVM::Environment.current
      rvm_strings = current.list_strings()


      if rvm_strings.select { |rvm_string| ! rvm_string.scan(ruby_string).empty? }.empty? then
        current.install ruby_string
      end

      current.rvm :use, "#{ruby_string}@#{gemset}", :create => true

    end
    action :create
  end
end
