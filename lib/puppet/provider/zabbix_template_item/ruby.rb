Puppet::Type.type(:zabbix_template_item).provide(:ruby) do
  desc "zabbix template item provider"
  confine :feature => :zabbixapi
  
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../../../../lib/ruby/")
  require "zabbix"


  def exists?
    extend Zabbix
    existing = zbx.items.get_id(
      :name => resource[:name],
      :key_ => resource[:key],
      :hostid => [zbx.templates.get_id( :host => resource[:template] )]
    ).is_a? Integer
    return(existing)
  end
  
  def create
    extend Zabbix
    
    apps_real = Array.new
    resource[:applications].each do |app|
      apps_real.push(
        zbx.applications.get_id( :name => app )
      )
    end
    zbx.items.create(
      :applications => apps_real,
      :delay => resource[:delay], #60
      :hostid => zbx.templates.get_id( :host => resource[:template] ),
      :interfaceid => resource[:interface],
      :key_ => resource[:key],
      :name => resource[:name],
      :type => resource[:type],
      :username => resource[:username],
      :value_type => resource[:value_type],
      :authtype => resource[:authtype],
      :data_type => resource[:data_type],
      :delay_flex => resource[:delay_flex],
      :delta => resource[:delta],
      :description => resource[:description]
    )
  end
  
  def destroy
    extend Zabbix
    zbx.items.delete(
      zbx.items.get_id(
        :name => resource[:name],
        :key_ => resource[:key],
        :hostid => [zbx.templates.get_id( :host => resource[:template] )]
      )
    )
  end
end