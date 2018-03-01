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
        'Gene name' => {
          name: :gene_name,
          fmt:  :s
        },
        'Accession Number' => {
          name: :accession_number,
          fmt:  :s
        },
#        'Gene CDS length' => {
#          name: :gene_cds_length,
#          fmt:  :i
#        },
        'HGNC ID' => {
          name: :hgnc_id,
          fmt:  :i
        },
        'ID_sample' => {
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
#        'Genome-wide screen' => {
#          name: :whole_genome_screen,
#          fmt:  :b
#        },
#        'Mutation ID' => {
#          name: :mutation_id,
#          fmt:  :s
#        },
#        'Mutation CDS' => {
#          name: :mutation_cds,
#          fmt:  :s
#        },
#        'Mutation AA' => {
#          name: :mutation_aa,
#          fmt:  :s
#        },
#        'Mutation Description' => {
#          name: :description,
#          fmt:  :s
#        },
#        'Mutation zygosity' => {
#          name: :zygosity,
#          fmt:  :s
#        },
#        'LOH' => {
#          name: :loh,
#          fmt:  :b
#        },
##        'GRCh' => {
#          name: :grch,
#          fmt:  :i
#        },
#        'Mutation genome position' => {
#          name: :genomic_position,
#          fmt:  :s
#        },
#        'Mutation strand' => {
#          name: :strand,
#          fmt:  :s
#        },
#        'SNP' => {
#          name: :snp,
#          fmt:  :b
#        },
#        'Resistance Mutation' => {
#          name: :resistance_mutation,
#          fmt:  :b
#        },
#        'FATHMM prediction' => {
#          name: :fathmm_prediction,
#          fmt:  :s
#        },
#        'FATHMM score' => {
#          name: :fathmm_score,
#          fmt:  :f
#        },
#        'Mutation somatic status' => {
#          name: :mutation_somatic_status,
#          fmt:  :s
#        },
#        'Pubmed_PMID' => {
#          name: :pmid,
#          fmt:  :i
#        },
#        'ID_STUDY' => {
#          name: :study_id,
#          fmt:  :i
#        },        
#        'Sample source' => {
#          name: :sample_source,
#          fmt:  :s
#        },   
#        'Tumour origin' => {
#          name: :tumour_origin,
#          fmt:  :s
#       }
        'Tier' => {
          name: :tier,
          fmt:  :i
       }
     }.freeze
    end
  end
end
