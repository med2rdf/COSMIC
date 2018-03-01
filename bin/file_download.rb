#! /bin/sh

# exec ruby -S -x "$0" "$@"
#! ruby

$: << File.dirname(File.expand_path(__FILE__, "../lib"))
require 'fileutils'
require 'pathname'
require "cosmic_rdf"

dl = CosmicRdf::Downloader.new(
  ENV['COSMIC_EMAIL'],
  ENV['COSMIC_PASS'],
  grch: 37,
  version: CosmicRdf::LATEST_VERSION
)

dest_dir = Pathname("/opt")
dl.download(dest_dir)
# dl.download(dest_dir, only: %i[mutation cna fusion])
