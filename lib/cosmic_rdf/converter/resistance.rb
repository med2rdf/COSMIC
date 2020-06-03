# coding: utf-8

require 'cosmic_rdf/converter/baseurl'
require 'cosmic_rdf/converter/base_items'

module CosmicRdf
  module Converter
    class Resistance < Baseurl
      # Gene include symbols.
      class Gene_Items < Base_Items
        attr_accessor :gene_name, :mutation_id, :sample_id, :pmid, :somatic_status, :census_gene, :drug_name, :tier
      end
      @ignore = []
      @add_info = []

      @title = "CosmicResistanceMutations"
      @label = "known to confer drug resistance"
      @keyword = "drug resistance"
      @distribution = "CosmicResistanceMutations.tsv.gz"

      @sample_ttl = []
      @sample_item = [:primary_site, :site_subtype_1, :site_subtype_2, :primary_histology, :histology_subtype_1, :histology_subtype_2, :zygosity]
      @sample_prefix = CosmicRdf::PREFIX[:sample].split(" ")[1].split(":")[0] + ":"

      @gene_hash = {}
      # override
      def self.rdf_turtle(obj)
        @row = obj
        # gene_id is hash-key.
        gene_id = @row.gene_name
        # それぞれのClassに値を代入
        @entry_hash = @gene_hash[gene_id] || {}
        key = @row.drug_name + ":" + @row.mutation_id.to_s + ":" + @row.sample_id.to_s
        entry = @entry_hash[key] || Gene_Items.new
        @entry_hash[key]  = set_items(entry)
        @gene_hash[gene_id] = @entry_hash
        return nil
      end

      @ignore += @sample_item 
      # return rdf if rdf_write over write.
      def self.alt_puts_rdf(fout)
        fout.puts @sample_ttl 
        # gene data in mutation-file
        puts @gene_hash.each_key
        @gene_hash.each_pair do |gene_id, entry_hash|
          next  if gene_id.nil?
          rdf_ttl = []
          gene_labels = gene_id.split('_')
          if gene_labels.length == 2 then
            rdf_ttl << "genedirect:#{gene_id} #{CosmicRdf::RDF_CLASS[:transcript]}" ## Subject
          else
            rdf_ttl << "genedirect:#{gene_id} a #{CosmicRdf::RDF_CLASS[:gene]} ;" ## Subject
          end
          rdf_ttl << "  rdfs:label \"#{gene_id}\" ;"
          census = entry_hash.values.first.send(:census_gene).first
          rdf_ttl << " #{@predicate}census \"#{census}\" ;"

          rdf_ttl << " #{@predicate}has_drug_resistences ["
          entry_hash.each_value do |gene_item|
            @row = gene_item
            rdf_ttl << " #{@predicate}drug_resistance ["
            rdf_ttl << "  #{CosmicRdf::RDF_CLASS[:resistance]}"
            Gene_Items.accessors.each do |item|
              vals = gene_item.send(item)
              case item
              when :gene_name
                rdf_ttl << gene_name
              when :census_gene
              when :mutation_id
                rdf_ttl << mutationid_relation(vals.first)
              when :sample_id
                rdf_ttl << sampleids_relation(vals)
              when :pmid
                rdf_ttl << pmid_relations(vals)
              when :somatic_status
                vals.each do |val|
                  rdf_ttl << default_rdf(item, val)
                end
              else
                puts "caution! duplicate item? #{item} #{vals}" if 
                  vals.size > 1
                val = vals.first
                rdf_ttl << default_rdf(item, val) unless val.to_s.empty?
              end
            end
            # 1-transcript data
            rdf_ttl << " ] ;"
          end
          rdf_ttl << " ] ."
          fout.puts(rdf_ttl)
        end
      end

      ## over write identifer
      def self.identifier_relation(ident)
        "<#{CosmicRdf::URIs[:mutation]}#{ident}>"
      end

      def self.sample_id
        ## Resistans Sample-info
        @sample_ttl << "#{@sample_prefix}#{@row.sample_id} #{CosmicRdf::RDF_CLASS[:sample]}"
        @sample_ttl << "  dcat:identifier \"COSS#{@row.sample_id}\" ;"
        @sample_item.each do |item|
          val = @row.send(item)
          next if val.nil? || val.to_s.empty?
          @sample_ttl << "  s:#{item} \"#{val}\" ;"
        end
        @sample_ttl << "."

        sampleid_relation(@row.sample_id)
      end

      def self.gene_name
        gene_relation(@row.gene_name.first)
      end

      def self.pmid
        pmid_relation(@row.pmid)
      end

      def self.somatic_status(val)
        status = 
          case val
            when 0; "Not specified"
            when 1; "Confirmed somatic variant"
            when 2; "Reported in another cancer sample as somatic"
            when 5; "Variant of unknown origin"
            when 7; "Systematic screen"
            when 21; "Likely cancer causing"
            when 22; "Possible cancer causing"
            when 23; "Unknown consequence"
            when 25; "To be decided"
            when 50; "Verified"
            when 51; "Unverified"
            when 52; "Unverified - SNP6"
            else "unknown"
          end
        return "  #{@predicate}somatic_status \"#{status}\" ;"
      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
          CosmicRdf::PREFIX[:mutation],
          CosmicRdf::PREFIX[:sample],
          CosmicRdf::PREDICATE_PREFIX[:sample],
          CosmicRdf::PREFIX[:genedirect]
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
