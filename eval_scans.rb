
require 'nmap/xml'

Dir["scan_*.xml"].each { |file|
    if File.readable? file
        Nmap::XML.new(file) do |xml|
            xml.each_host do |host|

                host.each_port do |port|
                    #p $open_ports[port.number].length
                    #$open_ports[port.number] << [host.ip, port.protocol, port.reason, port.service.to_s, port.state] if port.state == :open
                    #p [host.ip, port.protocol, port.reason, port.service.to_s, port.state]
                    if port.state == :open
                      puts "#{port.number} service #{port.service.to_s} IP #{host.ip} "
                    end
                end
            end
        end
    else
        STDERR.puts "#{file} is not readable"
    end
}

