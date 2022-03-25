# Yggdrasil port scanner
The port_scan.rb script can be used to perform a port scan of the entire Yggdrasil network using nmap and the corresponding Ruby library. The results are saved in the same folder in the format `scan_[thread]_[host index]-[five random characters].xml`.
port_scan.rb expects a yggnodes.json file, which is the result of a Yggdrasil crawler. An already completed file can be found under http://[316:c51a:62a3:8b9::2]/result.json or http://[300:7232:2b0e:d6e9:216:3eff:feb6:65a3]/nodeinfo.json.
The eval_scans.rb script summarizes the results in the following format: `[port] service [service name, e. g. nginx or apache] IP [IPv6 address]`

## Dependencies
- ruby gem ruby-nmap
- nmap

# Links
- Yggdrasil network: https://yggdrasil-network.github.io/
- Yggdrasil network map / Crawler: https://github.com/Arceliar/yggdrasil-map
-  Yggdrasil Network API  / Prepared json files: http://[316:c51a:62a3:8b9::2]/
