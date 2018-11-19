#
# Cookbook:: aqha-chef-solo-bootstrap
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

['awscli','epel-release','jq'].each do |package_name|
  yum_package package_name do
    action :upgrade
  end
end

directory node['aqha']['install_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "#{node['aqha']['install_dir']}/logs" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template "#{node['aqha']['install_dir']}/bootstrap.sh" do
  source 'bootstrap.erb'
  mode '0555'
  owner 'root'
  group 'root'
  variables(
    :install_dir => node['aqha']['install_dir'],
    :environment_name => node['aqha']['environment_name']
  )
end

cookbook_file "#{node['aqha']['install_dir']}/solo.rb" do
  source 'solo.rb'
  owner 'root'
  group 'root'
  mode '0644'
end

template "#{node['aqha']['install_dir']}/node.json" do
  source 'node_json.erb'
  mode '0555'
  owner 'root'
  group 'root'
  variables(
    :role_name => node['aqha']['role_name']
  )
end

systemd_unit 'aqha-chef-solo-bootstrap.service' do
  content({
    Unit: {
      Description: 'Aqha Chef Solo Bootstrap service',
      After: 'network.target',
    },
    Service: {
      Type: 'oneshot',
      ExecStart: "#{node['aqha']['install_dir']}/bootstrap.sh",
      Restart: 'no',
    },
    Install: {
      WantedBy: 'multi-user.target',
    }
  })
  action [:create, :enable]
end
