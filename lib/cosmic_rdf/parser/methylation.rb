# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Methylation < Tsv
      HEADERS = {
        'STUDY_ID' => {
          name: :study_id,
          fmt:  :i
        },
        'ID_SAMPLE' => {
          name: :sample_id,
          fmt:  :i
        },
#        'SAMPLE_NAME' => {
#          name: :sample_name,
#          fmt:  :s
#        },
#        'ID_TUMOUR' => {
#          name: :tumor_id,
#          fmt:  :i
#        },
#        'PRIMARY_SITE' => {
#          name: :primary_site,
#          fmt:  :n
#        },
#        'SITE_SUBTYPE_1' => {
#          name: :site_subtype_1,
#          fmt:  :n
#        },
#        'SITE_SUBTYPE_2' => {
#          name: :site_subtype_2,
#          fmt:  :n
#        },
#        'SITE_SUBTYPE_3' => {
#          name: :site_subtype_3,
#          fmt:  :n
#        },
#        'PRIMARY_HISTOLOGY' => {
#          name: :primary_histology,
#          fmt:  :n
#        },
#        'HISTOLOGY_SUBTYPE_1' => {
#          name: :histology_subtype_1,
#          fmt:  :n
#        },
#        'HISTOLOGY_SUBTYPE_2' => {
#          name: :histology_subtype_2,
#          fmt:  :n
#        },
#        'HISTOLOGY_SUBTYPE_3' => {
#          name: :histology_subtype_3,
#          fmt:  :n
#        },
        'FRAGMENT_ID' => {
          name: :fragment_id,
          fmt:  :s
        },
        'GENOME_VERSION' => {
          name: :grch,
          fmt:  :i
        },
        'CHROMOSOME' => {
          name: :chrom,
          fmt:  :s
        },
        'POSITION' => {
          name: :pos,
          fmt:  :i
        },
        'STRAND' => {
          name: :strand,
          fmt: ->(v) { v == '1' ? '+' : '-' }
        },
        'GENE_NAME' => {
          name: :gene_name,
          fmt:  :s
        },
        'METHYLATION' => {
          name: :methylation,
          fmt:  :s
        },
        'AVG_BETA_VALUE_NORMAL' => {
          name: :avg_beta_value_normal,
          fmt:  :f
        },
        'BETA_VALUE' => {
          name: :beta_value,
          fmt:  :f
        },
        'TWO_SIDED_P_VALUE' => {
          name: :two_sided_p_value,
          fmt:  :f
        }
      }.freeze
    end
  end
end
