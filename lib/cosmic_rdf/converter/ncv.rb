# coding: utf-8

require 'cosmic_rdf/converter/baseurl'
require 'cosmic_rdf/converter/base_items'

## Cosmic ncv 
module CosmicRdf
  module Converter
    class Ncv < Baseurl
      class Ncv_Items < Base_Items
        attr_accessor :zygosity, :grch, :genomic_position, :wt_seq, :mut_seq, :snp, :fathmm_mkl_non_coding_score, :fathmm_mkl_non_coding_groups, :fathmm_mkl_coding_score, :fathmm_mkl_coding_groups, :whole_genome_reseq, :whole_exome, :study_id, :pmid, :sample_id
      end
      #@ignore = []
      #@add_info = [:sample_id]

      @title = "COSMIC NCV"
      @label = "Non coding variants"
      @keyword = "ncvnon-coding"
      @distribution = "CosmicNCV.tsv.gz"

      @ncv_hash = {}
      # override
      def self.rdf_turtle(obj)
        @row = obj
        ncv_items = @ncv_hash[@row.ncv_id] || Ncv_Items.new
        @ncv_hash[@row.ncv_id] = set_items(ncv_items)
        return nil
      end

      # return rdf.
      def self.alt_puts_rdf(fout)
        @ncv_hash.each_pair do |ncv_id, ncv_items|
          rdf_ttl = []

          ## ncv-id COSN157810
          url_ncv_id = ncv_id.delete("COSN")
          rdf_ttl << "#{@current.to_sym}:#{url_ncv_id} #{so_type}" ## Subject
          rdf_ttl << "  dcat:identifier \"#{ncv_id}\" ;"
          
          ## ncv incude sample-ids
          ## ncv-id : sample-id = 1 : 1
          Ncv_Items.accessors.each do |item|
            ncv_items.send(item).each do |val|
              next if val.nil? || val.to_s.empty?
              rdf_ttl << 
              case item
                when :snp, :whole_genome_reseq, :whole_exome
                  default_rdf(item, is_true_false(val))
                when :pmid
                  pmid_relation(val)
                when :study_id
                  studyid_relation(val)
                when :sample_id
                  "  cosmic:sample sample:#{val};"
                when :wt_seq
                  "  med2rdf:referenceAlelle \"#{val}\" ;"
                when :mut_seq
                  " med2rdf:alterationAlelle \"#{val}\" ;"

                else 
                  default_rdf(item, val)
              end
            end
          end
          ## faldo position
          rdf_ttl << genomic_position(ncv_items.grch.first, ncv_items.genomic_position.first)
          # 1-sample data
          rdf_ttl << "."
          fout.puts rdf_ttl
        end
      end
      
      def self.genomic_position(grch, pos)
        chr, start_pos, end_pos = pos.split(/:|-/)
        if end_pos =~ /^[0-9]+$/
          post = end_pos.to_i + 1
          end_pos = post
        end
        return genomic_position_relation(start_pos, end_pos, ["grch#{grch}", "chr#{chr}"])
      end

      def self.is_true_false(val)
        res = 
          case val.to_s
            when "n"; "no"
            when "false"; "no"
            when "y"; "yes"
            when "true"; "yes"
            else "unknown"
          end
          # puts "#{val} -> #{res}"
        return res
      end


      def self.ident
        @row.ncv_id
      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
          CosmicRdf::PREFIX[:sample],
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
