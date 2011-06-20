#
# Cookbook Name:: zw_test
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/george" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

zw_rvm_install "ruby-1.9.2" do
  ruby_string "ruby-1.9.2"
  project_dir "/george"
  gemset "george"
end
