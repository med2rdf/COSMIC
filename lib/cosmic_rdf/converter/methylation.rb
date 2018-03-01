# coding: utf-8

require 'cosmic_rdf/converter/baseurl'
require 'cosmic_rdf/converter/base_items'
module CosmicRdf
  module Converter
    class Methylation < Baseurl
      class Methylation_Items < Base_Items
        attr_accessor :fragment_id, :grch, :chrom, :pos, :strand, :avg_beta_value_normal, :study_id, :sample_id, :methylation
      end
      class Sample_Items < Base_Items
        attr_accessor :sample_id, :methylation, :beta_value, :gene_name
      end
      @ignore = [:sample_id]
      #@add_info = [:fragment_id, :grch, :chrom, :pos, :strand, :methylation, :avg_beta_value_normal, :study_id]

      @title = "CosmicCompleteDifferentialMethylation"
      @label = "TCGA Level 3 methylation data"
      @keyword = "Methylation"
      @distribution = "CosmicCompleteDifferentialMethylation.tsv.gz"

      @met_hash = {}
      @smpl_hash = {}

      # override
      def self.rdf_turtle(obj)
        @row = obj
        met_items = @met_hash[ident] || Methylation_Items.new
        @met_hash[ident] = set_items(met_items)
        
        smpl_items = set_items(Sample_Items.new)
        met_sample = @smpl_hash[ident] || [] 
        met_sample << smpl_items
        @smpl_hash[ident] = met_sample
        return nil
      end

      # write rdf.
      def self.alt_puts_rdf(fout)
        @met_hash.each_pair do |frg_id, met_item|
          rdf_ttl = []
          rdf_ttl << "#{@current.to_sym}:#{frg_id} #{so_type}" ## Subject
          ## rdf_ttl << "  dcat:identifier \"#{frg_id}\" ;"
          rdf_ttl << "  rdfs:label \"ProbeId:#{frg_id}\" ;\n"
          Methylation_Items.accessors.each do |item|
            puts "caution! duplicate item? #{item} #{met_item.send(item)}" if 
              met_item.send(item).size > 1 && item != :sample_id
            next if @ignore.include?(item)
            val = met_item.send(item).first
            next  if val.nil? || val == ""
            rdf_ttl <<
            case item
              when :fragment_id; fragment_id(val)
              when :study_id;    studyid_relation(val)
              when :methylation; methylation(val)
              else default_rdf(item, val)
            end
          end

          ## sample info.
          rdf_ttl << "  #{@predicate}have_sample["
          rdf_ttl << "    #{CosmicRdf::RDF_CLASS[:sample]} "
          @smpl_hash[frg_id].each do |sample_item|
            gene_name_ttl = gene_name(sample_item)
            rdf_ttl << "    #{@predicate}sample ["
            rdf_ttl << "      dcat:identifier   \"COSS#{sample_item.sample_id.first}\" ;" ;
            rdf_ttl << "      cosmic:sample     sample:#{sample_item.sample_id.first} ;" ;
            rdf_ttl << "      s:beta_value      \"#{sample_item.beta_value.first}\" ;" ;
            rdf_ttl << gene_name_ttl unless gene_name_ttl.nil?
            rdf_ttl << "    ] ;"
          end
          rdf_ttl << "  ] ;"

          ## Faldoposition.
          rdf_ttl << "  faldo:location [\n" +
                     "    a faldo:ExactPosition ;\n" +
                     "    #{faldo_strand(met_item.strand.first)} #{met_item.pos.first} ; \n" +
                     "    faldo:reference \"grch#{met_item.grch.first}\" ; \n" +
                     "    faldo:reference \"chr#{met_item.chrom.first}\" \n" +
                     "  ]; \n"
          # 1-sample data
          rdf_ttl << "."
          fout.puts(rdf_ttl)
        end
      end

      def self.ident
        @row.fragment_id
      end

      def self.fragment_id(val)
        "  dcat:identifier \"#{val}\" ;" 
      end

      def self.gene_name(val)
        genename_relation(val.gene_name.first, "    ")
      end
      

      def self.methylation(val)
        ## methylation:level; H (High, beta-value >0.8) or L (Low, beta-value < 0.2).
        low_hight = 
          case val
            when "H"; "High"
            when "L"; "Low"
            else "unknown"
          end
        return "  #{@predicate}methylation  \"#{low_hight} \" ;" ;
      end

      def self.faldo_strand(val)
        faldo_strand = 
          case val
            when "-"; "faldo:ReverseStrandPosition"
            when "+"; "faldo:StrandedPosition"
            else "faldo:Position"
          end
        return faldo_strand
      end
      
      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
          CosmicRdf::PREDICATE_PREFIX[:sample],
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
