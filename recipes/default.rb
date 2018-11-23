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

template "#{node['aqha']['install_dir']}/bootstrap.sh" do
  source 'bootstrap.erb'
  mode '0555'
  owner 'root'
  group 'root'
  variables(
    :install_dir => node['aqha']['install_dir'],
    :bootstrap_environment_name => node['aqha']['bootstrap_environment_name']
  )
end

template "#{node['aqha']['install_dir']}/solo.rb" do
  source 'solo.erb'
  mode '0444'
  owner 'root'
  group 'root'
  variables(
    :install_dir => node['aqha']['install_dir'],
    :cookbooks_dir => node['aqha']['cookbooks_dir']
  )
end

template "#{node['aqha']['install_dir']}/node.json" do
  source 'node_json.erb'
  mode '0444'
  owner 'root'
  group 'root'
  variables(
    :bootstrap_role_name => node['aqha']['bootstrap_role_name']
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
