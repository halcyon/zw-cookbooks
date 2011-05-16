#
# Cookbook Name:: zw-redmine
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#
#

redmine_kanban_path = "/srv/redmine/current/vendor/plugins"

git "#{redmine_kanban_path}/redmine_kanban" do
  repository "git://github.com/edavis10/redmine_kanban.git"
  reference "v0.2.0"
  user 'vagrant'
  group 'vagrant'
  action :checkout
end

tasks = [ "db:migrate_plugins" ]

tasks.each do |task|
  execute "rake #{task}" do
    cwd redmine_kanban_path
    environment 'RAILS_ENV' => node.app_environment
  end
end
