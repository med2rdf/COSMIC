#! /bin/sh

# exec ruby -S -x "$0" "$@"
#! ruby

$: << File.expand_path('../lib' , __dir__)
require 'fileutils'
require 'pathname'
require 'cosmic_rdf'
require 'optparse'



def localmain()
  #create output directory.
  FileUtils.mkdir_p(@out_dir) unless FileTest.exist?(@out_dir)
  # if FileTest.exist?(@out_dir)
  #   bkdate = Date.today.strftime("%Y%m%d-%H%M%S")
  #   bk_out_dir = @out_dir + bkdate
  #   FileUtils.mv(@out_dir, bk_out_dir)
  #   FileUtils.mkdir_p(@out_dir)
  # end

  ## test.
  ## res = _test_rdf_create_mutation
  ## res = _test_rdf_create_sample
  ## exit
  
  CosmicRdf::FILES.each do |symbl, file|
    rdf_create(symbl)
  end
end

def rdf_create(symbl)
  puts "#{symbl} in progress"
  classify = symbl.capitalize
  cosmic_file = @dest_dir.join(CosmicRdf::FILES[symbl])
  rdf_file   =  @out_dir.join(CosmicRdf::RDFS[symbl])

  ## read, write file check.
  unless File.exist?(cosmic_file)
    puts "  #{cosmic_file} is not found! Please download it."
    return
  end

  if File.exist?(rdf_file)
    puts "  #{rdf_file} already exists. skip this file."
    return
  end
  parser = CosmicRdf::Parser.const_get(classify)
  converter = CosmicRdf::Converter.const_get(classify)
  parser.open(cosmic_file) do |tsv|
    converter.rdf_write(rdf_file, tsv)
  end
end


puts "start script..."
option={d: '/opt'}
OptionParser.new do |opt|
  opt.on('-d dir-path',   'default: /opt')   {|v| option[:d] = v}
  opt.parse!(ARGV)
end

# downloaded files directory
@dest_dir = Pathname(option[:d])
@out_dir  = @dest_dir.join('rdf')
puts "COSMIC downloaded-file directory : #{@dest_dir}"
puts "COSMIC parsed-rdf-file directory : #{@out_dir}"
res = localmain()
puts "end script..."