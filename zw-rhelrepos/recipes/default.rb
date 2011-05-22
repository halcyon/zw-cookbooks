#
# Cookbook Name:: zw-rhelrepos
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node['platform']['redhat']

  file "/etc/yum.repos.d/cobbler-config.repo" do
    action :delete
  end

  yum_key "RPM-GPG-KEY-oracle-el5" do
    url "http://public-yum.oracle.com/RPM-GPG-KEY-oracle-el5"
    action :add
  end

  yum_repository "el5_ga_base" do
    description "el5_ga_base"
    name "EL5-GA-repo-base"
    url "http://public-yum.oracle.com/repo/EnterpriseLinux/EL5/0/base/$basearch/"
    key "RPM-GPG-KEY-oracle-el5"
    action :add
  end

end
