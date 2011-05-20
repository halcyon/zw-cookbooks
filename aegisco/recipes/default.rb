#
# Cookbook Name:: aegisco
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum"

case node['platform']
when "redhat"
  yum_key "RPM-GPG-KEY-aegisco" do
    url "http://rpm.aegisco.com/aegisco/RPM-GPG-KEY-aegisco"
    action :add
  end

  yum_repository "aegisco" do
    description "aegisco"
    name "AegisCo-rhel5-repo-x86_64"
    url "http://rpm.aegisco.com/aegisco/rhel/5/x86_64/"
    key "RPM-GPG-KEY-aegisco"
    action :add
  end
end
