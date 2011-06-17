#
# Cookbook Name:: zw_test
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

zw_rvm_install "ruby-1.9.2" do
  set_default true
  gemset "jenkins"
end
