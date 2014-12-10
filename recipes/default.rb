#
# Cookbook Name:: aixjava
# Recipe:: default
#
# Copyright 2014, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

%w(jre sdk).each do |component|
  raise "You must define the URL for #{component}!" if node['aixjava'][component]['url'].nil?

  remote_file "#{Chef::Config[:file_cache_path]}/#{File.basename(node['aixjava'][component]['url'])}" do
    source node['aixjava'][component]['url']
    action :create
  end

  execute "untar #{component}" do
    command "gzip -dc #{Chef::Config[:file_cache_path]}/#{File.basename(node['aixjava'][component]['url'])} | tar xf -"
    cwd Chef::Config[:file_cache_path]
    creates "#{Chef::Config[:file_cache_path]}/#{node['aixjava'][component]['package']}"
  end

  package node['aixjava'][component]['package'] do
    source "#{Chef::Config[:file_cache_path]}/#{node['aixjava'][component]['package']}"
    action :install
  end
end


