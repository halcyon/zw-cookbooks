#
# Cookbook Name:: zw-rvmwrapper
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

rubystring = node[:rvm][:ruby_string]

#execute "for i in `ls /usr/local/rvm/gems/#{rubystring}/bin` ; do rvm wrapper #{rubystring} --no-prefix $i ; done"
#execute "for i in `ls /usr/local/rvm/gems/#{rubystring}/bin` ; do ln -sf /usr/local/rvm/bin/$i /usr/bin/$i ; done"

ruby_block "create rvm gem wrappers" do
  block do
    Dir.glob("/usr/local/rvm/gems/#{rubystring}/bin/*").each do |filepath|
      gembinary = File.basename filepath
      if not File::exists? "/usr/local/rvm/bin/#{gembinary}"
        system("rvm wrapper #{rubystring} --no-prefix #{gembinary}")
      end
      if not File::exists? "/usr/bin/#{gembinary}"
        FileUtils.ln_s("/usr/local/rvm/bin/#{gembinary}","/usr/bin/#{gembinary}")
      end
    end
  end
  action :create
end


