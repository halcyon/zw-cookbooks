#
# Cookbook Name:: zw-rvmwrapper
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ree = "ree-1.8.7-2011.03"

execute "for i in `ls /usr/local/rvm/gems/#{ree}/bin` ; do rvm wrapper #{ree} --no-prefix $i ; done"
execute "for i in `ls /usr/local/rvm/gems/#{ree}/bin` ; do ln -sf /usr/local/rvm/bin/$i /usr/bin/$i ; done"
