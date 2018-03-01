# coding: utf-8

require 'zlib'
require 'csv'
require 'active_support'
require 'active_support/core_ext'

require 'cosmic_rdf/parser/row'

module CosmicRdf
  module Parser

    class Tsv
      HEADERS = {}.freeze

      def initialize(cosmic_file)
        raise ArgumentError, "File not found: #{cosmic_file}" unless
          File.exist? cosmic_file
        basename = File.basename(cosmic_file)
        raise ArgumentError, "Invalid filename: #{basename}" unless
          FILES[self.class.name.split('::').last.underscore.to_sym] == basename
        
        # .csv or .gz
        if File.extname(cosmic_file) == '.gz'
          @io = Zlib::GzipReader.open(cosmic_file,  invalid: :replace, undef: :replace)
          @tsv = CSV.new(@io, col_sep: "\t", headers: :first_row, quote_char: "\a") ## unlikely Escape sequence....
        elsif File.extname(cosmic_file) == '.csv'
          @io = File.open(cosmic_file,  invalid: :replace, undef: :replace)
          @tsv = CSV.new(@io, col_sep: ',', headers: :first_row, quote_char: '"')
        else
          raise ArgumentError, "Invalid filetype: #{basename}"
        end
        
        
      end

      def self.open(tsv_file)
        obj = new(tsv_file)
        if block_given?
          begin
            yield obj
          # rescue CSV::MalformedCSVError
          ensure
            obj.close
          end
        else
          obj
        end
      end

      def each
        @tsv.each do |row|
          yield Row.new(row, self.class::HEADERS)
        end
      end

      def close
        @io.close
      end
    end
  end
end
