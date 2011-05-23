#
# Cookbook Name:: rvm
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

gem_package "mysql" do
  action :install
end

system "gem update --system 1.4.2"
