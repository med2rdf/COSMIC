# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Breakpoint < Tsv
      HEADERS = {
        'Sample name' => {
          name: :sample_name,
          fmt:  :s
        },
        'Primary site' => {
          name: :primary_site,
          fmt:  :n
        },
        'Site subtype 1' => {
          name: :site_subtype_1,
          fmt:  :n
        },
        'Site subtype 2' => {
          name: :site_subtype_2,
          fmt:  :n
        },
        'Site subtype 3' => {
          name: :site_subtype_3,
          fmt:  :n
        },
        'Primary histology' => {
          name: :primary_histology,
          fmt:  :n
        },
        'Histology subtype 1' => {
          name: :histology_subtype_1,
          fmt:  :n
        },
        'Histology subtype 2' => {
          name: :histology_subtype_2,
          fmt:  :n
        },
        'Histology subtype 3' => {
          name: :histology_subtype_3,
          fmt:  :n
        },
        'Mutation Type' => {
          name: :mutation_type,
          fmt:  :s
        },
        'Mutation ID' => {
          name: :mutation_id,
          fmt:  :i
        },
        'Breakpoint Order' => {
          name: :breakpoint,
          fmt:  :s
        },
        'GRCh' => {
          name: :grch,
          fmt:  :i
        },
        'Chrom From' => {
          name: :chrom_from,
          fmt:  :i
        },
        'Location From min' => {
          name: :location_from_min,
          fmt:  :i
        },
        'Location From max' => {
          name: :location_from_max,
          fmt:  :i
        },
        'Strand From' => {
          name: :strand_from,
          fmt:  :s
        },
        'Chrom To' => {
          name: :chrom_to,
          fmt:  :i
        },
        'Location To min' => {
          name: :location_to_min,
          fmt:  :i
        },
        'Location To max' => {
          name: :location_to_max,
          fmt:  :i
        },
        'Strand To' => {
          name: :strand_to,
          fmt:  :s
        },
        'Non-templated ins seq' => {
          name: :non_templated_ins_seq,
          fmt:  :s
        },
        'ID_STUDY' => {
          name: :study_id,
          fmt:  :i
        },
        'Pubmed ID' => {
          name: :pmid,
          fmt:  :i
        }
      }.freeze
    end
  end
end
