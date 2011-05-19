#
# Cookbook Name:: zw-rvmwrapper
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ruby_string = node[:rvm][:ruby_string]

#execute "for i in `ls /usr/local/rvm/gems/#{rubystring}/bin` ; do rvm wrapper #{rubystring} --no-prefix $i ; done"
#execute "for i in `ls /usr/local/rvm/gems/#{rubystring}/bin` ; do ln -sf /usr/local/rvm/bin/$i /usr/bin/$i ; done"

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

server_services = %w{ chef-solr chef-expander chef-server }

if node['chef_server']['webui_enabled']
  server_services << "chef-server-webui"
end

server_services.each do |svc|
  service "#{svc}" do
    supports :status => true
    action :enable
  end
end


