# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Resistance < Tsv
      HEADERS = {
        'Sample Name' => {
          name: :sample_name,
          fmt:  :s
        },
        'Sample ID' => {
          name: :sample_id,
          fmt:  :i
        },
        'Gene Name' => {
          name: :gene_name,
          fmt:  :s
        },
        'Transcript' => {
          name: :transcript,
          fmt:  :s
        },
        'Census Gene' => {
          name: :census_gene,
          fmt:  :b
        },
        'Drug Name' => {
          name: :drug_name,
          fmt:  :s
        },
        'ID Mutation' => {
          name: :mutation_id,
          fmt:  :s
        },
#        'AA Mutation' => {
#          name: :mutation_aa,
#          fmt:  :s
#        },
#        'CDS Mutation' => {
#          name: :mutation_cds,
#          fmt:  :s
#        },
        'Primary Tissue' => {
          name: :primary_site,
          fmt:  :n
        },
        'Tissue Subtype 1' => {
          name: :site_subtype_1,
          fmt:  :n
        },
        'Tissue Subtype 2' => {
          name: :site_subtype_2,
          fmt:  :n
        },
        'Tissue Subtype 3' => {
          name: :site_subtype_3,
          fmt:  :n
        },
        'Histology' => {
          name: :primary_histology,
          fmt:  :n
        },
        'Histology Subtype 1' => {
          name: :histology_subtype_1,
          fmt:  :n
        },
        'Histology Subtype 2' => {
          name: :histology_subtype_2,
          fmt:  :n
        },
        'Pubmed Id' => {
          name: :pmid,
          fmt:  :i
        },
        'CGP Study' => {
          name: :cgp_study,
          fmt:  :s
        },
        'Somatic Status' => {
          name: :somatic_status,
          fmt:  :i
        },
        'Sample Source' => {
          name: :sample_source,
          fmt:  :s
        },
        'Zygosity' => {
          name: :zygosity,
          fmt:  :s
        },
#        'Genome Coordinates (GRCh37)' => {
#          name: :genomic_position,
#          fmt: ->(v) { v.blank? || v == ':..' ? nil : v }
#        }
      }.freeze
    end
  end
end
