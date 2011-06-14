#
# Cookbook Name:: zw_jenkins
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

case node[:platform]
when "redhat"
  execute "install jenkins rpm from URL" do
    command "rpm -Uhv http://mirrors.jenkins-ci.org/redhat/jenkins-1.415-1.1.noarch.rpm"
    action :run
  end
end
