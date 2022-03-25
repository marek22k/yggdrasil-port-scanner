require 'json'
require 'nmap/program'
require 'nmap/xml'

# such a file can be found at
# http://[316:c51a:62a3:8b9::2]/result.json
# or
# http://[300:7232:2b0e:d6e9:216:3eff:feb6:65a3]/nodeinfo.json
filename = "yggnodes.json"
threads_n = 16
$ports = [80, 443, 8008, 8448]

puts "Do a port scan on the yggdrasil network. Scan ports [#{$ports.join ', '}]. Reading nodes from #{filename}. Using #{threads_n} for scanning."

puts "Read #{filename}"
json = File.read 'yggnodes.json'
puts "Parse json "
data = JSON.parse json

puts "Collecting addresses"
addrs = []
data['yggnodes'].each_value { |node|
    addrs << node['address']
}


#
#  yggnodes
#    public keys
#      address
#      coords
#      dht
#      nodeinfo
#      peers
#      time

per_thread = addrs.length / threads_n
rest = addrs.length % threads_n

puts "Split addresses for threads"

parts = []
for i in 0...threads_n
    parts << addrs[i * per_thread ... (i+1) * per_thread]
end

rest_part = addrs[-rest..-1]

threads = []

def generate_code(number)
  charset = Array('A'..'Z') + Array('a'..'z')
  Array.new(number) { charset.sample }.join
end

def work_on_address addr, ident
    Nmap::Program.scan do |nmap|
        nmap.service_scan = true
        nmap.xml = "scan_#{ident}-#{generate_code(5)}.xml"
        nmap.ipv6 = true

        nmap.ports = $ports
        nmap.targets = addr
    end
end

threads << Thread.new {
    puts "Start extra thread"
    rest_part.each_with_index { |addr, index|
        work_on_address addr, "r_#{index}"
    }
    puts "Extra thread complete"
}

for i in 0...threads_n
    threads << Thread.new(i) { |num|
        puts "Start thread #{num + 1}"
        parts[num].each_with_index { |addr, index|
            work_on_address addr, "#{num}_#{index}"
        }
        puts "Stop thread #{num + 1}"
    }
end

puts "Waiting for threads to finish"
threads.each { |th|
    th.join
}

