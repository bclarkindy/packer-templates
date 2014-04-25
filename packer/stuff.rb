#!/usr/bin/env ruby

require 'json'


def run_cmd(cmd)
  result = `#{cmd} 2>&1`
  status = $?.to_i
  return result, status
end

in_file = ARGV[0]

result, status = run_cmd("date")
#result, status = run_cmd("packer validate #{in_file}")
unless status == 0
  puts result
  exit status
end

template = JSON.parse(IO.read(in_file))

qemu_builder = {}
template['builders'].each do |builder|
    next unless builder['type'] == 'qemu'
    directory = builder['output_directory']
    vm_name = builder['vm_name']
    disk_size = builder.has_key?('disk_size') ? builder['disk_size'].to_i / 1024 : 40

    
end


