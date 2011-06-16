action :create do
  ruby_block "install ruby" do
    block do
      require 'rvm'
    end
    action :create
  end
end
