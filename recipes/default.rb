#
# Cookbook Name:: devstack
# Recipe:: default
#
# Copyright (c) 2012, OpenStack, LLC
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

include_recipe "apt"

package "git"

execute "git clone #{node[:devstack][:repository]}" do
  cwd node[:devstack][:dir]
  user node[:devstack][:user]
  group node[:devstack][:group]
  not_if { File.directory?("#{node[:devstack][:dir]}/devstack") }
end

execute "git checkout #{node[:devstack][:branch]}" do
  cwd "#{node[:devstack][:dir]}/devstack"
  user node[:devstack][:user]
  group node[:devstack][:group]
end

template "#{node[:devstack][:dir]}/devstack/localrc" do
  source "localrc.erb"
  owner node[:devstack][:user]
  group node[:devstack][:group]
  mode 0644
end

execute "killall screen || true"

execute "su -c 'set -e; cd #{node[:devstack][:dir]}/devstack; RECLONE=yes bash stack.sh > devstack.log' #{node[:devstack][:user]}"
