# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Struct < Baseurl
      class Struct_Items < Base_Items
        attr_accessor :mutation_id, :mutation_type, :grch, :description, :pmid, :study_id, :sample_name
      end

      class Sample_Items < Base_Items
        attr_accessor :sample_name, :primary_site, :site_subtype_1, :site_subtype_2, :site_subtype_3, :primary_histology, :histology_subtype_1, :histology_subtype_2, :histology_subtype_3
      end

      # @ignore = []
      # @add_info = [:mutation_id]
      @title = "Structural Genomic Rearrangements"
      @label = "cosmic structural variants"
      @keyword = "structural variant"
      @distribution = "CosmicStructExport.tsv.gz"

      @mut_hash = {}
      @smpl_hash = {}
      # override
      def self.rdf_turtle(obj)
        @row = obj
        strct_items = @mut_hash[ident]  || Struct_Items.new
        smpl_items  = @smpl_hash[@row.sample_name] || Sample_Items.new
        @mut_hash[ident] = set_items(strct_items)
        @smpl_hash[@row.sample_name] = set_items(smpl_items)
        return nil
      end
      
      # return rdf then rdf_turtle is override
      def self.alt_puts_rdf(fout)
        @mut_hash.each_pair do |mut_id, stct_items|
          rdf_ttl = []
          rdf_ttl << "struct:#{mut_id} #{so_type};" ## Subject
          rdf_ttl << "  dcat:identifier \"#{mut_id}\" ;"
          
          ## incude sample-ids
          rdf_ttl << sample_names(stct_items.sample_name)
          Struct_Items.accessors.each do |item|
            stct_items.send(item).each do |val|
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
          
          rdf_ttl << genomic_position(mut_id, stct_items.grch.first, stct_items.description.first)
          # 1-sample data
          fout.puts(rdf_ttl)
        end
        ## Struct have sample-dat
        add_info_sample_names(fout,Sample_Items)
      end
      
      def self.ident
        @row.mutation_id
      end

      def self.mutation_id
        return mutationid_relation(@row.mutation_id)
      end

      def self.sample_names(sample_names)
        sample_ttl = []
        sample_ttl << "  #{@predicate}samples[ \n"
        sample_names.each do |sample_name|
          sample_ttl << "    cosmic:sample_name s:#{sample_name} ;"
        end
        sample_ttl << "  ] ;\n"
        return sample_ttl
      end
      
      def self.genomic_position(mut_id, grch, pos)
        _ar = pos.split(/:|_|\./)
        case _ar.size
          # -> grch, schr, s1, s2, rchr, r1, r2
          when 4
            #puts "#4 #{pos} #{_ar}"
            # #4 chr3:g.176492834_178335312del ["chr3", "g", "176492834", "178335312del"]
            genomic_position_faldo(mut_id, grch, _ar[0], _ar[2], _ar[2], _ar[0], _ar[3], _ar[3])
          when 5
            # puts "#5 #{pos} #{_ar}"
            # #5 chrX:g.7836497_chrX:7948758bkpt ["chrX", "g", "7836497", "chrX", "7948758bkpt"]
            genomic_position_faldo(mut_id, grch, _ar[0], _ar[2], _ar[2], _ar[3], _ar[4], _ar[4])
          when 6
            # puts "#6 #{pos} #{_ar}"
            # #6 chr12:g.(86078963_86078983)_(86079015_86079035)del ["chr12", "g", "(86078963", "86078983)", "(86079015", "86079035)del"]
            genomic_position_faldo(mut_id, grch, _ar[0], _ar[2], _ar[3], _ar[0], _ar[4], _ar[5])
          when 7
            # puts "#7 #{pos} #{_ar}"
            # #7 chr22:g.(38603015_38603035)_chr14:(23203718_23203738)bkpt ["chr22", "g", "(38603015", "38603035)", "chr14", "(23203718", "23203738)bkpt"]
            genomic_position_faldo(mut_id, grch, _ar[0], _ar[2], _ar[3], _ar[4], _ar[5], _ar[6])
          when 8    
            # puts "#8 #{pos} #{_ar}"
            # 
            genomic_position_faldo(mut_id, grch, _ar[0], _ar[2], _ar[3], _ar[5], _ar[6], _ar[7])
          else 
            puts "not parce ----- #{pos}"
            return "."
        end

      end 

      def self.genomic_position_faldo(mut_id, grch, schr, s1, s2, rchr, r1, r2)
        schr.sub!(/^chr/, "")
        s1.gsub!(/[^\d+]/, "")
        s2.gsub!(/[^\d+]/, "")
        rchr.sub!(/^chr/, "")
        r1.gsub!(/[^\d+]/, "")
        r2.gsub!(/[^\d+]/, "")
        sf = s1.to_i <= s2.to_i ? "faldo:ForwardStrandPosition" : "faldo:ReverseStrandPosition"
        s2.to_i + 1 if s1.to_i == s2.to_i

        sr = r1.to_i <= r2.to_i ? "faldo:ForwardStrandPosition" : "faldo:ReverseStrandPosition"
        r2.to_i + 1 if r1.to_i == r2.to_i
        
        rdf_ttl = []
        rdf_ttl << "  sio:SIO_000974 #{@current}:#{mut_id}#1, #{@current}:#{mut_id}#2 ;"
        rdf_ttl << "."
        
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
        rdf_ttl << "      a faldo:ExactPosition, #{sr} ;"
        rdf_ttl << "      faldo:position #{r1} ;"
        rdf_ttl << "      faldo:reference \"grch#{grch}\" ;"
        rdf_ttl << "      faldo:reference \"chr#{rchr}\" ;"
        rdf_ttl << "    ] ;"
        rdf_ttl << "    faldo:end   [ "
        rdf_ttl << "      a faldo:ExactPosition, #{sr} ;"
        rdf_ttl << "      faldo:position #{r2} ;"
        rdf_ttl << "      faldo:reference \"grch#{grch}\" ;"
        rdf_ttl << "      faldo:reference \"chr#{rchr}\" ;"
        rdf_ttl << "    ] ;"
        rdf_ttl << "  ] ;"
        rdf_ttl << "."
        return rdf_ttl
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
