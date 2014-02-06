# Copyright 2011, Dell 
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 
#  http://www.apache.org/licenses/LICENSE-2.0 
# 
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License. 
# 

class GlanceService < ServiceObject

  def initialize(thelogger)
    @bc_name = "glance"
    @logger = thelogger
  end

# Turn off multi proposal support till it really works and people ask for it.
  def self.allow_multiple_proposals?
    false
  end

  def proposal_dependencies(role)
    answer = []
    answer << { "barclamp" => "haproxy", "inst" => role.default_attributes[@bc_name]["haproxy_instance"] }
    answer << { "barclamp" => "percona", "inst" => role.default_attributes[@bc_name]["percona_instance"] }
    answer << { "barclamp" => "keystone", "inst" => role.default_attributes[@bc_name]["keystone_instance"] }
    answer
  end

  def create_proposal
    @logger.debug("Glance create_proposal: entering")
    base = super

    # HAProxy dependency
    base["attributes"][@bc_name]["haproxy_instance"] = ""
    begin
      haproxyService = HaproxyService.new(@logger)
      haproxys = haproxyService.list_active[1]
      if haproxys.empty?
        # No actives, look for proposals
        haproxys = haproxyService.proposals[1]
      end
      base["attributes"][@bc_name]["haproxy_instance"] = haproxys[0] unless haproxys.empty?
    rescue
      @logger.info("Glance create_proposal: no haproxy found")
    end
    if base["attributes"][@bc_name]["haproxy_instance"] == ""
      raise(I18n.t('model.service.dependency_missing', :name => @bc_name, :dependson => "haproxy"))
    end

    # Percona dependency
    base["attributes"][@bc_name]["percona_instance"] = ""
    begin
      perconaService = PerconaService.new(@logger)
      perconas = perconaService.list_active[1]
      if perconas.empty?
        # No actives, look for proposals
        perconas = perconaService.proposals[1]
      end
      base["attributes"][@bc_name]["percona_instance"] = perconas[0] unless perconas.empty?
    rescue
      @logger.info("Glance create_proposal: no percona found")
    end
    if base["attributes"][@bc_name]["percona_instance"] == ""
      raise(I18n.t('model.service.dependency_missing', :name => @bc_name, :dependson => "percona"))
    end

    # Keystone dependency
    base["attributes"][@bc_name]["keystone_instance"] = ""
    begin
      keystoneService = KeystoneService.new(@logger)
      keystones = keystoneService.list_active[1]
      if keystones.empty?
        # No actives, look for proposals
        keystones = keystoneService.proposals[1]
      end
      base["attributes"][@bc_name]["keystone_instance"] = keystones[0] unless keystones.empty?
    rescue
      @logger.info("Glance create_proposal: no keystone found")
    end
    if base["attributes"][@bc_name]["keystone_instance"] == ""
      raise(I18n.t('model.service.dependency_missing', :name => @bc_name, :dependson => "keystone"))
    end

#    nodes = NodeObject.all
#    nodes.delete_if { |n| n.nil? or n.admin? }
#    if nodes.size >= 1
#      base["deployment"]["glance"]["elements"] = {
#        "glance-server" => [ nodes.first[:fqdn] ]
#      }
#    end

    #Set random password for glance service
    base["attributes"]["glance"]["service_password"] = '%012d' % rand(1e12)
    base["attributes"]["glance"]["db"]["password"] = random_password 

    @logger.debug("Glance create_proposal: exiting")
    base
  end

  def apply_role_pre_chef_call(old_role, role, all_nodes)
    @logger.debug("Glance apply_role_pre_chef_call: entering #{all_nodes.inspect}")
    return if all_nodes.empty?

    # Update images paths
    nodes = NodeObject.find("roles:provisioner-server")
    unless nodes.nil? or nodes.length < 1
      admin_ip = nodes[0].get_network_by_type("admin")["address"]
      web_port = nodes[0]["provisioner"]["web_port"]
      # substitute the admin web portal
      new_array = []
      role.default_attributes["glance"]["images"].each do |item|
        new_array << item.gsub("|ADMINWEB|", "#{admin_ip}:#{web_port}")
      end
      role.default_attributes["glance"]["images"] = new_array
      role.save
    end

    # Make sure the bind hosts are in the admin network
=begin  all_nodes.each do |n|
      node = NodeObject.find_node_by_name n

      admin_address = node.get_network_by_type("admin")["address"]
      node.crowbar[:glance] = {} if node.crowbar[:glance].nil?
      node.crowbar[:glance][:api_bind_host] = admin_address
      node.crowbar[:glance][:registry_bind_host] = admin_address

      node.save
    end
=end  
   @logger.debug("Glance apply_role_pre_chef_call: leaving")
  end
end

