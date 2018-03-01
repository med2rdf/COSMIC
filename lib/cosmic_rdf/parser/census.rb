# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    # @example
    #   CosmicRdf::Parser::Mutation.open('CosmicMutantExport.tsv.gz') do |tsv|
    #     tsv.each do |row|
    #       pp row
    #     end
    #   end
    class Census < Tsv
      HEADERS = {
        'Gene Symbol' => {
          name: :gene_name,
          fmt:  :s
        },
        'Name' => {
          name: :gene_desc,
          fmt:  :s
        },
        'Entrez GeneId' => {
          name: :entrez_id,
          fmt:  :i
        },
        'Genome Location' => {
          name: :genomic_position,
          fmt:  :s
        },
        'Tier' => {
          name: :tier,
          fmt:  :i
        },
        'Hallmark' => {
          name: :hallmark,
          fmt:  :s
        },
        'Chr Band' => {
          name: :chr_band,
          fmt:  :s
        },
        'Somatic' => {
          name: :somatic,
          fmt:  :s
        },
        'Germline' => {
          name: :germline,
          fmt:  :s
        },
        'Tumour Types(Somatic)' => {
          name: :somatic_tumour_types,
          fmt:  :s
        },
        'Tumour Types(Germline)' => {
          name: :germline_tumour_types,
          fmt:  :s
        },
        'Cancer Syndrome' => {
          name: :cancer_syndrome,
          fmt:  :s
        },
        'Tissue Type' => {
          name: :tissue,
          fmt:  :s
        },
        'Molecular Genetics' => {
          name: :molecular_genetics,
          fmt:  :s
        },
        'Role in Cancer' => {
          name: :role,
          fmt:  :s
        },
        'Mutation Types' => {
          name: :mutation_type,
          fmt:  :s
        },
        'Translocation Partner' => {
          name: :translocation_partner,
          fmt:  :s
        },
        'Other Germline Mut' => {
          name: :other_germline,
          fmt:  :s
        },
        'Other Syndrome' => {
          name: :other_syndrome,
          fmt:  :s
        },
        'Synonyms' => {
          name: :synonyms,
          fmt:  :s
        },
      }.freeze
    end
  end
end
