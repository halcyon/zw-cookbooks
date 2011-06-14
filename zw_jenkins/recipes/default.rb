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
  execute "Install Jenkins rpm from URL" do
    command "rpm -Uhv http://mirrors.jenkins-ci.org/redhat/jenkins-1.415-1.1.noarch.rpm"
    not_if "rpm -q jenkins"
    action :run
  end
  execute "Upgrade Jenkins" do
    command "yum upgrade"
    action :run
  end
end

service "jenkins" do
  suppots :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end
