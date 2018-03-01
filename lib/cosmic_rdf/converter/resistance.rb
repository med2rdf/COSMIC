# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Resistance < Baseurl
      @ignore = []
      @add_info = [:sample_id, :gene_name, :mutation_id, :transcript, :pmid, :somatic_status]

      @title = "CosmicResistanceMutations"
      @label = "known to confer drug resistance"
      @keyword = "drug resistance"
      @distribution = "CosmicResistanceMutations.tsv.gz"

      @sample_ttl = []
      @sample_item = [:primary_site, :site_subtype_1, :site_subtype_2, :primary_histology, :histology_subtype_1, :histology_subtype_2, :zygosity]
      @sample_prefix = CosmicRdf::PREFIX[:sample].split(" ")[1].split(":")[0] + ":"

      @ignore += @sample_item 
      # return rdf if rdf_write over write.
      def self.alt_puts_rdf(fout)
        fout.puts @sample_ttl 
      end

      ## over write identifer
      def self.identifier_relation(ident)
        "<#{CosmicRdf::URIs[:mutation]}#{ident}>"
      end
      
      def self.ident
        @row.mutation_id.delete!("COSM")
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
        genename_relation(@row.gene_name)
      end

      def self.mutation_id
        # return mutationid_relation(@row.mutation_id)
      end

      def self.transcript
        genesymbol_relation(@row.transcript)
      end
      
      def self.pmid
        pmid_relation(@row.pmid)
      end

      def self.somatic_status
        status = 
          case @row.somatic_status
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
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
