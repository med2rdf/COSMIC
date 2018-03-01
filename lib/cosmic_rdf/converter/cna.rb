# coding: utf-8

require 'cosmic_rdf/converter/baseurl'
require 'cosmic_rdf/converter/base_items'

module CosmicRdf
  module Converter
    class Cna < Baseurl
      class Sample_Items < Base_Items
        attr_accessor  :sample_id, :gene_id
      end
      class Gene_Items < Base_Items
        attr_accessor :gene_id, :gene_name, :grch 
      end
      class Cna_Items < Base_Items
        attr_accessor  :total_cn, :minor_allele, :mut_type, :study_id, :genomic_position
      end

      @ignore = [:gene_id]
      @add_info = [:study_id ]

      @title = "COSMIC CompleteCNA"
      @label = "cosmic copy number abberations"
      @keyword = "copy number"
      @distribution = "CosmicCompleteCNA.tsv.gz"

      @cna_id_separater = "::"
      @sample_hash = {}
      @gene_hash = {}
      @cna_hash = {}
      # override
      def self.rdf_turtle(obj)
        @row = obj
        cna_id =   @row.sample_id.to_s + @cna_id_separater + @row.gene_id.to_s
        sample_items  = @sample_hash[ident] || Sample_Items.new
        gene_items   = @gene_hash[@row.gene_id] || Gene_Items.new
        cna_items  = set_items(Cna_Items.new)

        @sample_hash[ident] = set_items(sample_items)
        @gene_hash[@row.gene_id] = set_items(gene_items)
        cna_mut = @cna_hash[cna_id] || []
        cna_mut << cna_items
        @cna_hash[cna_id] = cna_mut
        return nil
      end

      # return rdf then rdf_turtle is override
      def self.alt_puts_rdf(fout)
        @sample_hash.each_pair do |sample_id, sample_items|
          rdf_ttl = []
          rdf_ttl << "sample:#{sample_id} #{CosmicRdf::RDF_CLASS[:sample]}" ## Subject is sample 
          rdf_ttl << "  dcat:identifier \"COSS#{sample_id}\" ;"

          # sample have gene info
          sample_items.gene_id.each do |sample_gene_id|
            gene_item = @gene_hash[sample_gene_id]
            rdf_ttl << "  cosmic:gene [ "   #
            rdf_ttl << "    a #{CosmicRdf::RDF_CLASS[:gene]} ;"   #
            Gene_Items.accessors.each do |gitem|
              next if gene_item.send(gitem).nil? || gene_item.send(gitem).empty?
              ## caution debug...
              puts "caution: cnv duplicate value: #{gitem} in sample_id:#{sample_id} gene_id:#{sample_gene_id}" if gene_item.send(gitem).size > 1
              val = gene_item.send(gitem).first
              case gitem
                when :gene_id
                  rdf_ttl << gene_id(val)
                when :gene_name
                  rdf_ttl << gene_name(val)
                else 
                  rdf_ttl << default_rdf(gitem, val)
              end
            end ## Gene_Items

            ## level-3
            cna_id = sample_items.sample_id.first.to_s + @cna_id_separater + gene_item.gene_id.first.to_s
            @cna_hash[cna_id].each do |cna_item|
              rdf_ttl << "    cosmic:mutation [ "
              rdf_ttl << "      #{so_type(cna_item.mut_type.first)} "
              Cna_Items.accessors.each do |citem|
              next if cna_item.send(citem).nil? || cna_item.send(citem).empty?
              puts "caution: cnv duplicate value: #{citem} in sample_id:#{sample_id} gene_id:#{sample_gene_id}" if cna_item.send(citem).size > 1
              val = cna_item.send(citem).first
                case citem
                  when :total_cn
                    rdf_ttl << default_rdf(citem, val)
                  when :minor_allele
                    rdf_ttl << default_rdf(citem, val)
                  when :mut_type
                    rdf_ttl << default_rdf(citem, val)
                  when :study_id
                    rdf_ttl << study_id(val)
                  when :genomic_position
                    rdf_ttl << default_rdf("genomic_position", val)
                    rdf_ttl << genomic_position(gene_item.grch.first, val)
                  when :mut_type
                    rdf_ttl << default_rdf(citem, val)
                  else
                    rdf_ttl << default_rdf(citem, val)
                end
              end
              rdf_ttl << "    ] ;"
            end
            rdf_ttl << "  ] ;"
          end
          # 1-sample data
          rdf_ttl << "."
          fout.puts(rdf_ttl)
        end
      end
      
      def self.ident
        @row.sample_id
      end

      def self.gene_id(val)
        "    dcat:identifier \"COSG#{val}\" ;"
      end
      
      def self.gene_name(gene_name)
        # genename_relation(gene_name)
        "    rdfs:label \"#{gene_name}\" ;\n" +
        "    rdfs:seeAlso cosmicgene:#{gene_name} ;" 
      end

      def self.study_id(study_id)
        studyid_relation(study_id)
      end

      def self.genomic_position(grch, pos)
        chr, start_pos, end_pos = pos.split(/:|\.\./)
        ## ? pos is nil
        return genomic_position_relation(start_pos, end_pos, ["grch#{grch}", "chr#{chr}"])
      end

      ## over write.
      def self.so_type(val)
        case val
          when "gain"; CosmicRdf::RDF_CLASS[:cna_gain]
          when "loss"; CosmicRdf::RDF_CLASS[:cna_loss]
          else CosmicRdf::RDF_CLASS[:cna]
        end
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
