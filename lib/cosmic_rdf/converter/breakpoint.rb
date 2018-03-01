# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Breakpoint < Baseurl
      class Brakepoint_Items < Base_Items
        attr_accessor :mutation_type,:mutation_id,:breakpoint,:grch,:chrom_from,:location_from_min,:location_from_max,:strand_from,:chrom_to,:location_to_min,:location_to_max,:strand_to,:non_templated_ins_seq,:pmid,:study_id,:sample_name
      end

      class Sample_Items < Base_Items
        attr_accessor :sample_name, :primary_site, :site_subtype_1, :site_subtype_2, :site_subtype_3, :primary_histology, :histology_subtype_1, :histology_subtype_2, :histology_subtype_3
      end

      # @ignore = []
      # @add_info = [:mutation_id]
      @title = "Cosmic Breakpoints Export"
      @label = "breakpoint data"
      @keyword = "breakpoint"
      @distribution = "CosmicBreakpointsExport.tsv.gz"

      @sample_name_prefix = "sample:"
      @mut_hash = {}
      @smpl_hash = {}
      # override
      def self.rdf_turtle(obj)
        @row = obj
        break_items = @mut_hash[ident]  || Brakepoint_Items.new
        smpl_items  = @smpl_hash[@row.sample_name] || Sample_Items.new
        @mut_hash[ident] = set_items(break_items)
        @smpl_hash[@row.sample_name] = set_items(smpl_items)
        return nil
      end
      
      # return rdf then rdf_turtle is override
      def self.alt_puts_rdf(fout)
        @mut_hash.each_pair do |mut_id, break_items|
          rdf_ttl = []
          rdf_ttl << "#{@current}:#{mut_id} #{so_type}" ## Subject
          rdf_ttl << "  dcat:identifier \"#{mut_id}\" ;"
          
          ## incude sample-ids
          rdf_ttl << sample_names_ttl(break_items.sample_name)
          Brakepoint_Items.accessors.each do |item|
            break_items.send(item).each do |val|
              next if val.nil? || val.to_s.empty?
              next if item == :mutation_id
              next if item == :sample_name
              rdf_ttl << 
              case item
                when :study_id
                  studyid_relation(val)
                when :pmid
                  pmid_relation(val)
                else
                  default_rdf(item, val)
              end
            end
          end

          rdf_ttl << genomic_position(break_items)
          # 1-sample data
          # rdf_ttl << "."
          fout.puts(rdf_ttl)
        end
        ## Struct have sample-dat
        @smpl_hash.each_pair do |smpl_name, smpl_items|
          rdf_ttl = []
          rdf_ttl << "#{@sample_name_prefix}#{smpl_name} #{CosmicRdf::RDF_CLASS[:sample]}" ## Subject
          Sample_Items.accessors.each do |item|
            smpl_items.send(item).each do |val|
              next if val.nil? || val.to_s.empty?
              next if item == :sample_name
              ## st: -> s: 
              rdf_ttl << "  s:#{item} \"#{val}\" ;"
            end
          end
          rdf_ttl << "  rdfs:seeAlso  <#{CosmicRdf::URIs[:cosmic_search]}#{smpl_name}> ;\n"
          rdf_ttl << "."
          fout.puts(rdf_ttl)
        end
      end

      def self.ident
        @row.mutation_id
      end

      def self.sample_names_ttl(sample_names)
        sample_ttl = []
        sample_ttl << "  cosmic:samples [ \n"
        sample_names.each do |smpl_name|
          sample_ttl << "    cosmic:sample #{@sample_name_prefix}#{smpl_name} ;"
        end
        sample_ttl << "  ] ;\n"
        return sample_ttl
      end

      def self.genomic_position(item)
        rdf_ttl = []
        mut_id = item.mutation_id.first
        rdf_ttl << "  sio:SIO_000974 #{@current}:#{mut_id}#1, #{@current}:#{mut_id}#2 ;"
        rdf_ttl << "."

        sf, st, s1, s2, r1, r2 = ""
        if item.strand_from.first == "+"
          s1 = item.location_from_min.first
          s2 = item.location_from_max.first
          sf = "faldo:ForwardStrandPosition"
        else 
          s2 = item.location_from_min.first
          s1 = item.location_from_max.first
          sf = "faldo:ReverseStrandPosition"
        end
        
        if item.strand_to.first == "+"
          r1 = item.location_to_min.first
          r2 = item.location_to_max.first
          st = "faldo:ForwardStrandPosition"
        else 
          r2 = item.location_to_min.first
          r1 = item.location_to_max.first
          st = "faldo:ReverseStrandPosition"
        end

        grch = item.grch.first
        schr = item.chrom_from.first
        rchr = item.chrom_to.first

        rdf_ttl << "#{@current}:#{mut_id}#1 sio:SIO_000300 1 ;"
        rdf_ttl << "  faldo:location ["
        rdf_ttl << "    a faldo:Region ;"
        rdf_ttl << "    faldo:begin ["
        rdf_ttl << "      a faldo:ExactPosition, #{sf} ;"
        rdf_ttl << "      faldo:position #{s1} ;"
        rdf_ttl << "      faldo:reference \"grch#{grch}\" ;"
        rdf_ttl << "      faldo:reference \"chr#{schr}\" ;"
        rdf_ttl << "    ] ;"
        rdf_ttl << "    faldo:end   [ "
        rdf_ttl << "      a faldo:ExactPosition, #{sf} ;"
        rdf_ttl << "      faldo:position #{s2} ;"
        rdf_ttl << "      faldo:reference \"grch#{grch}\" ;"
        rdf_ttl << "      faldo:reference \"chr#{schr}\" ;"
        rdf_ttl << "    ] ;"
        rdf_ttl << "  ] ;"
        rdf_ttl << "."
        rdf_ttl << "#{@current}:#{mut_id}#2 sio:SIO_000300 2 ;"
        rdf_ttl << "  faldo:location ["
        rdf_ttl << "    a faldo:Region ;"
        rdf_ttl << "    faldo:begin ["
        rdf_ttl << "      a faldo:ExactPosition, #{st} ;"
        rdf_ttl << "      faldo:position #{r1} ;"
        rdf_ttl << "      faldo:reference \"grch#{grch}\" ;"
        rdf_ttl << "      faldo:reference \"chr#{rchr}\" ;"
        rdf_ttl << "    ] ;"
        rdf_ttl << "    faldo:end   [ "
        rdf_ttl << "      a faldo:ExactPosition, #{st} ;"
        rdf_ttl << "      faldo:position #{r2} ;"
        rdf_ttl << "      faldo:reference \"grch#{grch}\" ;"
        rdf_ttl << "      faldo:reference \"chr#{rchr}\" ;"
        rdf_ttl << "    ] ;"
        rdf_ttl << "  ] ;"
        rdf_ttl << "."

      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:sample],
          CosmicRdf::PREDICATE_PREFIX[:sample],
          CosmicRdf::PREFIX[:sio],
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
