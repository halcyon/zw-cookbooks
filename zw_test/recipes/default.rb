#
# Cookbook Name:: zw_test
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#ca = data_bag_item('zw','ca')
ca = Chef::EncryptedDataBagItem.load("zw", "ca")

zw_jks_keystore "CN=example.example.com, OU=Example, O=Example, L=Atlanta, ST=GA, C=US" do
  cn_alias "example"
  ca_url ca["ca_url"]
  ca_user ca["ca_user"]
  ca_pass ca["ca_pass"]
  store_pass ca["store_pass"]
  user_agent ca["user_agent"]
  jks_path "/srv/keystore.jks"
  action :create
  provider "zw_jks_keystore"
end
