#
# Cookbook Name:: zw_yumrepos
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

yum_repository "epel-erlang" do
  description "epel-erlang"
  url 'http://repos.fedorapeople.org/repos/peter/erlang/epel-$releasever/$basearch/'
  action :add
end
