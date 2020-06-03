# coding: utf-8

require 'cosmic_rdf/converter/baseurl'
require 'cosmic_rdf/converter/base_items'
module CosmicRdf
  module Converter
    class Mutation < Baseurl
      # Mutation include symbols.
      class Mutation_Items < Base_Items
        attr_accessor :mutation_id, :gene_name, :mutation_cds, :mutation_aa, :description, :genomic_position, :grch, :strand, :snp, :mutation_somatic_status, :fathmm_prediction, :fathmm_score, :sample_id, :pmid, :hgvsp, :hgvsc, :hgvsg
      end
      # Gene include symbols.
      class Gene_Items < Base_Items
        attr_accessor :hgnc_id, :gene_name, :accession_number, :gene_cds_length
      end
      # Sample include symbols.
      class Sample_Items < Base_Items
        attr_accessor :sample_id, :sample_name, :zygosity, :study_id, :sample_source, :tumour_origin, :primary_site, :site_subtype_1, :site_subtype_2, :site_subtype_3, :primary_histology, :histology_subtype_1, :histology_subtype_2, :histology_subtype_3, :age, :pmid
      end


      @title = "COSMIC MUTATION"
      @label = "cosmic mutation"
      @keyword = "mutation"
      @distribution = "CosmicMutantExport.tsv.gz"

      @ignore = [:mutation_id, :sample_id]

      @mut_hash = {}
      @smpl_hash = {}
      @gene_hash = {}
      # override
      def self.rdf_turtle(obj)
        @row = obj
        # mutation_id sample_id is hash-key.
        mut_id = @row.mutation_id
        smpl_id = @row.sample_id
        gene_id = @row.gene_name
        # id をKeyにしたClassを保持
        mut_items = @mut_hash[mut_id] || Mutation_Items.new
        smpl_items = @smpl_hash[smpl_id] || Sample_Items.new
        gene_items = @gene_hash[gene_id] || Gene_Items.new
        # それぞれのClassに値を代入
        @mut_hash[mut_id] = set_items(mut_items)
        @smpl_hash[smpl_id] = set_items(smpl_items)
        @gene_hash[gene_id] = set_items(gene_items)
        return nil
      end

      # return rdf.
      def self.alt_puts_rdf(fout)
        @mut_hash.each_pair do |mut_id, mut_item|
          # puts "### #{name} is mutation-id"
          rdf_ttl = []
          @after_rdf = []
          @mutid = mut_id.delete('COSM')
          rdf_ttl << "#{@current.to_sym}:#{@mutid} #{so_type(mut_item.description)}, #{CosmicRdf::RDF_CLASS[:variation]} ;" ## Subject
          rdf_ttl << "  dcat:identifier \"#{mut_id}\" ;"
          
          @row = mut_item
          Mutation_Items.accessors.each do |item|
            vals = mut_item.send(item)
            next  if vals.nil? || vals.length == 0
            next  if @ignore.include?(item)

            rdf_ttl <<
            case item
              when :sample_id
                    sampleids_relation(vals)
              when :pmid  
                    pmid_relations(vals)
              when :gene_name
                    gene_name
              when :genomic_position
                    genomic_position
              when :mutation_cds
                    mutation_cds
              when :mutation_somatic_status  
                    mutation_somatic_status(vals)
              when :grch
              #when :description,:grch,:genomic_position,:snp,:fathmm_prediction,:fathmm_score
              else
                  puts "caution! duplicate item? #{item} #{vals}" if 
                    vals.size > 1
                  default_rdf(item, vals.first)
            end
          end
          # 1-mutation data
          rdf_ttl << "."
          fout.puts(rdf_ttl)
          ## after rdf(mutation positions)
          fout.puts(@after_rdf)
        end

        # sample data in mutation-file
        @smpl_hash.each_pair do |smpl_id, smpl_item|
          @row = smpl_item
          rdf_ttl = []
          rdf_ttl << "sample:#{smpl_id} #{CosmicRdf::RDF_CLASS[:sample]} ;" ## Subject
          rdf_ttl << "  dcat:identifier \"COSS#{smpl_id}\" ;"
          Sample_Items.accessors.each do |item|
            vals = smpl_item.send(item)
            vals.each do |val|
              next if val.nil? || val.to_s.empty?
              next if val.to_s == "NS"
              case item
                when :study_id
                  study_ttl = studyid_relation(val)
                  rdf_ttl << study_ttl unless study_ttl.nil?
                else
                  rdf_ttl << default_rdf(item, val)
              end
            end
          end
          # 1-sample data
          rdf_ttl << "."
          fout.puts(rdf_ttl)
        end

        # gene data in mutation-file
        @gene_hash.each_pair do |gene_id, gene_item|
          @row = gene_item
          next  if gene_id.nil? || gene_item.to_s.empty?
          gene_labels = gene_id.split('_')
          gene_label = gene_labels[0]
          rdf_ttl = []
          rdf_ttl << "genedirect:#{gene_label} a #{CosmicRdf::RDF_CLASS[:gene]} ;" ## Subject
          rdf_ttl << "  rdfs:label \"#{gene_label}\" ;"
          Gene_Items.accessors.each do |item|
            vals = gene_item.send(item)
            vals.each do |val|
              next if val.nil? || val.to_s.empty?
              case item
              when :hgnc_id
                  rdf_ttl << hgnc_id
              when :gene_cds_length
                  rdf_ttl << gene_cds_length
              else

              end
            end
          end
          # 1-gene data
          rdf_ttl << "."
          fout.puts(rdf_ttl)

          if gene_labels.length == 2 then
            rdf_ttl = []
            rdf_ttl << "genedirect:#{gene_id} #{CosmicRdf::RDF_CLASS[:transcript]}" ## Subject
            rdf_ttl << "  rdfs:label \"#{gene_id}\" ;"
            Gene_Items.accessors.each do |item|
              vals = gene_item.send(item)
              vals.each do |val|
                next if val.nil? || val.to_s.empty?
                case item
                when :accession_number
                    rdf_ttl << accession_number
                else
                    
                end
              end
          end
            # 1-transcript data
            rdf_ttl << "."
            fout.puts(rdf_ttl)
	      end
        end
      end

      def self.ident
        @row.mutation_id
      end

      def self.gene_name
        gene_relation(@row.gene_name.first)
      end

      def self.hgnc_id
        ret = ""
        ids = @row.hgnc_id
        ids.each do |id|
          ret += hgnc_relation(id)
        end
        return ret
      end
      
      def self.accession_number
        ret = ""
        ids = @row.accession_number
        ids.each do |id|
          ret += genesymbol_relation(id)
        end
        return ret
      end

      def self.gene_cds_length
        "  #{@predicate}cds_length #{@row.gene_cds_length.first} ;"
      end
      
      def self.genomic_position
        pos = @row.genomic_position.first
        rdf_ttl = []
        rdf_ttl << default_rdf("genomic_position", pos)

        chr, pos1 , pos2 = pos.split(/:|-/)
        start_pos, end_pos = genomic_start_end_pos(pos1, pos2)
        return rdf_ttl if start_pos.nil?

        rdf_ttl << genomic_position_relation(start_pos, end_pos, ["<http://identifiers.org/hco/#{chr}#GRCh#{@row.grch.first}>"])
        return rdf_ttl
      end

      def self.genomic_start_end_pos(pos1, pos2)
        ## number exception check.
        if pos1.nil? || pos1.empty? || !pos1 =~ /^[0-9]+$/ ||
           pos2.nil? || pos2.empty? || !pos2 =~ /^[0-9]+$/ 
          return nil
        end

        strand = @row.strand.first
        start_pos, end_pos = ""
        if pos1 == pos2    # snp, ins
          if strand == '+'
            start_pos = pos1
            end_pos   = pos2.to_i + 1
          elsif strand == '-'
            start_pos = pos2
            end_pos   = pos1.to_i - 1
          end
          
        else ## del
          if strand == '+'
            start_pos = pos1
            end_pos   = pos2
          elsif strand == '-'
            start_pos = pos2
            end_pos   = pos1
          end
        end

        return nil if start_pos.to_s.empty? || end_pos.to_s.empty? 
        return [start_pos, end_pos]
      end
      
      def self.mutation_cds
        rdf_ttl = []
        rdf_ttl << default_rdf("mutation_cds", @row.mutation_cds.first)
        mut_ref_alt = mutation_nuc(@row.mutation_cds.first)
        rdf_ttl << mut_ref_alt unless mut_ref_alt.nil? || mut_ref_alt.empty?
      end

      def self.mutation_somatic_status(vals)
        vals.uniq!
        rdf_ttl = []
        vals.each do |val|
          rdf_ttl << "    cosmic:status \"#{val}\" ;"
        end
        return rdf_ttl
      end

      def self.so_type(description)
        desc = description.first || "Other"
        rdf_type = "a obo:" +
          case desc
            when "Substitution - Missense" ;          "SO_0001583"
            when "Substitution - coding silent" ;     "SO_0001819"
            when "Frameshift" ;                       "SO_0001589"
            when "Deletion - Frameshift" ;            "SO_0001910"
            when "Insertion - Frameshift" ;           "SO_0001909"
            when "Deletion - In frame" ;              "SO_0001822"
            when "Insertion - In frame" ;             "SO_0001821"
            when "Nonstop extension" ;                "SO_0001578"
            when "Substitution - Nonsense" ;          "SO_0001587"
            when "Complex" ;                          "SO_1000005"
            when "Complex - compound substitution" ;  "SO_1000005"
            when "Complex - insertion inframe" ;      "SO_0001577"
            when "Complex - deletion inframe" ;       "SO_0001577"
            when "Complex - frameshift" ;             "SO_0000865"
            when "Whole gene deletion" ;              "SO_0000045"
            when "Unknown" ;                          "SO_0001060"
            else "SO_0001564"  ## gene_variant
          end
        return rdf_type
      end

      def self.use_prefix
        prefix =[
          CosmicRdf::PREFIX[:cosmicgene],
          CosmicRdf::PREFIX[:sample],
          CosmicRdf::PREFIX[:genedirect],
          CosmicRdf::PREFIX[:study],
          CosmicRdf::PREFIX[:hgncurl],
          CosmicRdf::PREFIX[:ensembl]
        ]
      end
    end #- end Class
  end #- end Converter
end #- end CosmicRdf
