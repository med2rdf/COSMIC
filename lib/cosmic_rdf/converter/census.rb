# coding: utf-8

require 'cosmic_rdf/converter/baseurl'

module CosmicRdf
  module Converter
    class Census < Baseurl
      @ignore    = []
      @add_info  = [:gene_name, 
                    :entrez_id, 
                    :hallmark, 
                    :tissue,
                    :molecular_genetics,
                    :role,
                    :mutation_type,
                    :genomic_position,
                    :gene_desc,
                    #:tier,
                    #:other_germline,
      ]

      @title = "COSMIC MUTATION CENSUS"
      @label = "cosmic census"
      @keyword = "cancer census"
      @distribution = "cancer_gene_census.csv"

      ABBREVIATIONS = { 
        'A' => 'Amplification' ,
        'AEL' => 'Acute eosinophilic leukemia' ,
        'AL' => 'Acute leukemia' ,
        'ALCL' => 'Anaplastic large-cell lymphoma' ,
        'ALL' => 'Acute lymphocytic leukemia' ,
        'AML' => 'Acute myelogenous leukemia' ,
        'AML*' => 'Acute myelogenous leukemia (primarily treatment associated)' ,
        'APL' => 'Acute promyelocytic leukemia' ,
        'B-ALL' => 'B-cell acute lymphocytic leukaemia' ,
        'B-CLL' => 'B-cell Lymphocytic leukemia' ,
        'B-NHL' => 'B-cell Non-Hodgkin Lymphoma' ,
        'CLL' => 'Chronic lymphatic leukemia' ,
        'CML' => 'Chronic myeloid leukemia' ,
        'CMML' => 'Chronic myelomonocytic leukemia' ,
        'CNS' => 'Central nervous system' ,
        'D' => 'Large deletion' ,
        'DFSP' => 'Dermatofibrosarcoma protuberans' ,
        'DLBL' => 'Diffuse large B-cell lymphoma' ,
        'DLCL' => 'Diffuse large-cell lymphoma' ,
        'DOM' => 'Dominant' ,
        'E' => 'Epithelial' ,
        'F' => 'Frameshift' ,
        'GIST' => 'Gastrointestinal stromal tumour' ,
        'JMML' => 'Juvenile myelomonocytic leukemia' ,
        'L' => 'Leukaemia/lymphoma' ,
        'M' => 'Mesenchymal' ,
        'MALT' => 'Mucosa-associated lymphoid tissue lymphoma' ,
        'MDS' => 'Myelodysplastic syndrome' ,
        'MIS' => 'Missense' ,
        'MLCLS' => 'Mediastinal large cell lymphoma with sclerosis' ,
        'MM' => 'Multiple myeloma' ,
        'MPD' => 'Myeloproliferative disorder' ,
        'N' => 'Nonsense' ,
        'NHL' => 'Non-Hodgkin lymphoma' ,
        'NK/T' => 'Natural killer T cell' ,
        'NSCLC' => 'Non small cell lung cancer' ,
        'O' => 'Other' ,
        'PMBL' => 'Primary mediastinal B-cell lymphoma' ,
        'PRE-B' => 'All Pre-B-cell acute lymphoblastic leukaemia' ,
        'REC' => 'Recesive' ,
        'S' => 'Splice site' ,
        'T' => 'Translocation' ,
        'T-ALL' => 'T-cell acute lymphoblastic leukemia' ,
        'T-CLL' => 'T-cell chronic lymphocytic leukaemia' ,
        'TGCT' => 'Testicular germ cell tumour' ,
        'T-PLL' => 'T cell prolymphocytic leukaemia' ,
#      }.freeze
#      ROLE ={
        'ONCOGENE' =>  'hyperactivity of the gene drives the transformation' ,
        'TSG' =>       'loss of gene function drives the transformation. Some genes can play either of these roles depending on cancer type.' ,
        'FUSION' =>    'the gene is known to be involved in oncogenic fusions.' ,
      }.freeze

      def self.alt_puts_rdf(fout)
      end
      
      def self.ident
        @row.gene_name
      end

      def self.gene_name
        # genename_relation(@row.gene_name)

        return nil
      end

      def self.entrez_id
        entrez_id_relation(@row.entrez_id)
      end

      def self.hallmark
        return "  rdfs:seeAlso <#{CosmicRdf::URIs[:cosmiccensus]}#{@row.gene_name}> ;\n" if 
          @row.hallmark != nil && @row.hallmark.downcase == 'yes'
        return nil
      end
      
      def self.tissue
        return rdf_elm(
            "tissue", 
            @row.tissue,
            CosmicRdf::RDF_CLASS[:tissue])
      end

      def self.molecular_genetics
        # genetics
        return rdf_elm(
            "molecular_genetics",
            @row.molecular_genetics, 
            CosmicRdf::RDF_CLASS[:mol_genetics])
      end
     
      def self.mutation_type
        return rdf_elm(
              "mutation_type", 
              @row.mutation_type, 
              CosmicRdf::RDF_CLASS[:mut_type])
      end

      def self.role
        # cancer 
        return rdf_elm(
            "role", 
            @row.role, 
            CosmicRdf::RDF_CLASS[:role])
      end

      def self.rdf_elm(name, str, rdfclass)
        return nil if str.nil? || str.empty?
        rdf_ttl = []
        rdf_ttl << "  #{@predicate}#{name} ["
        rdf_ttl << "    a #{rdfclass};" unless rdfclass.empty?
        str.split(/\,|\//).each do |s|
          s.strip!
          s.upcase!
          # rdf_ttl << "      #{@predicate}#{name} \"#{s}\" ;"
          rdf_ttl << "    rdfs:label \"#{ABBREVIATIONS[s]}\" ;"
        end
        # rdf_ttl.pop
        rdf_ttl << "  ] ;"
        return rdf_ttl.join("\n")
      end

      def self.genomic_position
        rdf_ttl = []
        rdf_ttl << default_rdf("genomic_position", @row.genomic_position)

        chr,start_pos, end_pos = @row.genomic_position.split(/:|-/)
        rdf_ttl << genomic_position_relation(start_pos, end_pos, ["chr#{chr}"]) unless
          chr.nil? || start_pos.nil? || end_pos.nil?
        return rdf_ttl
      end

      def self.other_germline
        if @row.other_germline.nil? || @row.other_germline.empty?
          return "  #{@predicate}other_germline: false ;" 
        elsif @row.other_germline.downcase == 'yes'
          return "  #{@predicate}other_germline: true ;" 
        else
          return nil
        end
      end

      def self.gene_desc
        return "  rdfs:label \"#{@row.gene_desc}\" ;"
      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
          CosmicRdf::PREFIX[:ncbigene],
        ]
      end

      
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
