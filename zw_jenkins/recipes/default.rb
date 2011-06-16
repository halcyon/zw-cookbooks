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
when "debian"
  execute "Install Jenkins deb from URL" do
    command "(wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -); echo 'deb http://pkg.jenkins-ci.org/debian binary/' > /etc/apt/sources.list.d/jenkins.list; aptitude update; aptitude -y install jenkins"
    not_if "dpkg-query -s jenkins"
  end
end

jenkins = Chef::EncryptedDataBagItem.load("apps", "jenkins")
ca = Chef::EncryptedDataBagItem.load("apps", "ca")

zw_jks_keystore "CN=example.example.com, OU=Example, O=Example, L=Atlanta, ST=GA, C=US" do
  cn_alias "example"
  ca_url ca["ca_url"]
  ca_user ca["ca_user"]
  ca_pass ca["ca_pass"]
  store_pass ca["store_pass"]
  user_agent ca["user_agent"]
  jks_path jenkins["jks_path"]
  action :create
  provider "zw_jks_keystore"
end

template "/etc/sysconfig/jenkins" do
  source "jenkins.erb"
  variables ({
    :httpsPort => jenkins["httpsPort"],
    :jks_path => jenkins["jks_path"],
    :store_pass => jenkins["store_pass"]
  })
  notifies :restart, "service[jenkins]"
end

service "jenkins" do
  supports :restart => true, :reload => true, :status => true
  action [ :enable, :start ]
end
