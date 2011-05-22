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
    name "Enterprise Linux $releasever GA - $basearch - base"
    url "http://public-yum.oracle.com/repo/EnterpriseLinux/EL5/0/base/$basearch/"
    key "RPM-GPG-KEY-oracle-el5"
    action :add
  end

  yum_repository "el5_u5_base" do
    description "el5_u5_base"
    name "Enterprise Linux $releasever U5 - $basearch - base"
    url "http://public-yum.oracle.com/repo/EnterpriseLinux/EL5/5/base/$basearch/"
    key "RPM-GPG-KEY-oracle-el5"
    action :add
  end

  yum_repository "ol5_u5_base" do
    description "ol5_u5_base"
    name "Oracle Linux $releasever - U5 - x86_64 - base"
    url "http://public-yum.oracle.com/repo/OracleLinux/OL5/5/base/x86_64/"
    key "RPM-GPG-KEY-oracle-el5"
    action :add
  end

  yum_repository "el5_addons" do
    description "el5_addons"
    name "Enterprise Linux $releasever - $basearch - addons"
    url "http://public-yum.oracle.com/repo/EnterpriseLinux/EL5/addons/$basearch/"
    key "RPM-GPG-KEY-oracle-el5"
    action :add
  end

  yum_repository "el5_oracle_addons" do
    description "el5_oracle_addons"
    name "Enterprise Linux $releasever - $basearch - oracle_addons"
    url "http://public-yum.oracle.com/repo/EnterpriseLinux/EL5/oracle_addons/$basearch/"
    key "RPM-GPG-KEY-oracle-el5"
    action :add
  end

end
