# coding: utf-8

require 'cosmic_rdf/parser/tsv'

module CosmicRdf
  module Parser
    class Ncv < Tsv
      HEADERS = {
#        'Sample name' => {
#          name: :sample_name,
#          fmt:  :s
#        },
        'ID_SAMPLE' => {
          name: :sample_id,
          fmt:  :i
        },
#        'ID_tumour' => {
#          name: :tumor_id,
#          fmt:  :i
#        },
#        'Primary site' => {
#          name: :primary_site,
#          fmt:  :n
#        },
#        'Site subtype 1' => {
#          name: :site_subtype_1,
#          fmt:  :n
#        },
#        'Site subtype 2' => {
#          name: :site_subtype_2,
#          fmt:  :n
#        },
#        'Site subtype 3' => {
#          name: :site_subtype_3,
#          fmt:  :n
#        },
#        'Primary histology' => {
#          name: :primary_histology,
#          fmt:  :n
#        },
#        'Histology subtype 1' => {
#          name: :histology_subtype_1,
#          fmt:  :n
#        },
#        'Histology subtype 2' => {
#          name: :histology_subtype_2,
#          fmt:  :n
#        },
#        'Histology subtype 3' => {
#          name: :histology_subtype_3,
#          fmt:  :n
#        },
        'ID_NCV' => {
          name: :ncv_id,
          fmt:  :s
        },
        'zygosity' => {
          name: :zygosity,
          fmt:  :s
        },
        'GRCh' => {
          name: :grch,
          fmt:  :i
        },
        'genome position' => {
          name: :genomic_position,
          fmt:  :s
        },
#        'Mutation somatic status' => {
#          name: :mutation_somatic_status,
#          fmt:  :s
#        },
        'WT_SEQ' => {
          name: :wt_seq,
          fmt:  :s
        },
        'MUT_SEQ' => {
          name: :mut_seq,
          fmt:  :s
        },
        'SNP' => {
          name: :snp,
          fmt:  :s
        },
        'FATHMM_MKL_NON_CODING_SCORE' => {
          name: :fathmm_mkl_non_coding_score,
          fmt:  :f
        },
        'FATHMM_MKL_NON_CODING_GROUPS' => {
          name: :fathmm_mkl_non_coding_groups,
          fmt:  :s
        },
        'FATHMM_MKL_CODING_SCORE' => {
          name: :fathmm_mkl_coding_score,
          fmt:  :f
        },
        'FATHMM_MKL_CODING_GROUPS' => {
          name: :fathmm_mkl_coding_groups,
          fmt:  :i
        },
        'Whole_Genome_Reseq' => {
          name: :whole_genome_reseq,
          fmt:  :b
        },
        'Whole_Exome' => {
          name: :whole_exome,
          fmt:  :b
        },
        'ID_STUDY' => {
          name: :study_id,
          fmt:  :i
        },
        'PUBMED_PMID' => {
          name: :pmid,
          fmt:  :i
        }
      }.freeze
    end
  end
end
