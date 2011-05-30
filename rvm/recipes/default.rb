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

rvm_wrapper "create rvm wrappers" do
  ruby_string "ree-1.8.7-2011.03"
  action :create
  provider "rvm_wrapper"
end
