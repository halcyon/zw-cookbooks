#
# Cookbook Name:: zw-rvmwrapper
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ruby_string = node[:rvm][:ruby_string]

ruby_block "create rvm gem wrappers" do
  block do
    Dir.glob("/usr/local/rvm/gems/#{ruby_string}/bin/*").each do |file_path|
      gem_binary = File.basename file_path
      if not File::exists? "/usr/local/rvm/bin/#{gem_binary}"
        system("rvm wrapper #{ruby_string} --no-prefix #{gem_binary}")
      end
      if not File::exists? "/usr/bin/#{gem_binary}"
        FileUtils.ln_s("/usr/local/rvm/bin/#{gem_binary}","/usr/bin/#{gem_binary}")
      end
    end
  end
  action :create
end