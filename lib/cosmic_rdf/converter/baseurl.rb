# coding: utf-8

module CosmicRdf
  module Converter
    class Baseurl
      def initialize()
        # puts "### #{self.class} ###"
      end
      
      # read gzip-file-obj
      def self.rdf_write(rdf_file, tsv)
        @current = self.name.split('::').last.underscore.to_sym
        @predicate = CosmicRdf::PREDICATE_PREFIX[@current.to_sym].split(" ")[1].split(":")[0] + ":"
        
        File.open(rdf_file,"w") do |f|
          f.puts define_header
          f.puts use_prefix
          f.puts CosmicRdf::PREDICATE_PREFIX[:cosmic]
          f.puts CosmicRdf::PREFIX[@current]  unless CosmicRdf::PREFIX[@current].empty?
          f.puts CosmicRdf::PREDICATE_PREFIX[@current]
          f.puts ""
          f.puts rdf_catalog
          f.puts ""
          tsv.each do |obj|
            rdf_block = rdf_turtle(obj)
            f.puts rdf_block unless rdf_block.nil?
          end
          # file-end.
          alt_puts_rdf(f)
        end
      end

      def self.rdf_turtle(obj)
        @row = obj
        row_ident = ident
        rdf_ttl = []
        rdf_ttl << identifier_relation(row_ident)
        @row.attributes.each do |name, val|
          next if val.nil? || val.to_s.empty? 
          case
            when @add_info.include?(name)
              rdf_turtle = self.send(name)
              rdf_ttl << rdf_turtle unless rdf_turtle.nil?
            when @ignore.include?(name)
              # rdf_ttl <<  "  #{@predicate}#{name} \"#{self.send(name)}\" ;"
            else 
              rdf_ttl << default_rdf(name, val) 
          end
        end

        rdf_ttl << "."
        return rdf_ttl
      end

      def self.default_rdf(name, val)
        rdf_ttl = []
        rdf_ttl << "  rdfs:label \"#{val}\" ;" if 
          name == :gene_name
        if val.is_a?(Integer) || val.is_a?(Float) || val.is_a?(FalseClass) || val.is_a?(TrueClass)
          rdf_ttl << "  #{@predicate}#{name} #{val} ;"
        else
          rdf_ttl << "  #{@predicate}#{name} \"#{val}\" ;"
        end
        return rdf_ttl
      end
      
      def self.identifier_relation(ident)
        "<#{CosmicRdf::URIs[@current.to_sym]}#{ident}> #{so_type}"
      end

      def self.so_type
        CosmicRdf::RDF_CLASS[@current]
      end

      ## incude sample-ids
      def self.sampleids_relation(sample_ids)
        #sample_ids.sort!
        sample_ids.uniq!
        rdf_ttl = []
        sample_ids.each do |sample_id|
          rdf_ttl << "    cosmic:sample sample:#{sample_id};"
        end
        return rdf_ttl
      end

      def self.genename_relation(cosmic_gene_name, add_inx="")
        return nil if cosmic_gene_name =~ /Unclassifi/

        if cosmic_gene_name.to_s =~ /^[A-Z0-9]+$/
          return "" +
                 #"  #{@predicate}cosmic_gene_name[\n" +
                 "#{add_inx}  cosmic:gene [\n" +
                 "#{add_inx}     a #{CosmicRdf::RDF_CLASS[:gene]};\n" +
                 "#{add_inx}     rdfs:label \"#{cosmic_gene_name}\";\n" +
                 "#{add_inx}     dct:references <#{CosmicRdf::URIs[:cosmicgene]}#{cosmic_gene_name}>\n"+
                 #"#{add_inx}     rdfs:seeAlso cosmicgene:#{cosmic_gene_name}\n"+
                 "#{add_inx}  ] ;"
        end
        unless cosmic_gene_name.nil?
          return "#{add_inx}  cosmic:gene [\n" +
                 "#{add_inx}     a #{CosmicRdf::RDF_CLASS[:gene]};\n" +
                 "#{add_inx}     #{@predicate}gene_name \"#{cosmic_gene_name}\";\n" +
                 "#{add_inx}     dct:references <#{CosmicRdf::URIs[:genedirect]}#{cosmic_gene_name}>\n"+
                 "#{add_inx}  ] ;"
        end
        return nil
      end

      def self.gene_relation(cosmic_gene_name)
        return nil if cosmic_gene_name =~ /Unclassifi/
        unless cosmic_gene_name.nil?
          gene_labels = cosmic_gene_name.split('_')
          gene_label = gene_labels[0]
          ret = "  med2rdf:gene genedirect:#{gene_label};\n"
          if gene_labels.length == 2 then
            return ret + "  med2rdf:transcipt genedirect:#{cosmic_gene_name};\n"
          else
            return ret
          end
        end
        return nil
      end

      def self.genesymbol_relation(acc, add_inx="")
        return nil if acc == "Unclassified_Cell_type_specific"
        if acc =~ /^((AC|AP|NC|NG|NM|NP|NR|NT|NW|XM|XP|XR|YP|ZP)_\d+|(NZ\_[A-Z]{4}\d+))(\.\d+)?$/
          return  "#{add_inx}  cosmic:refseq[\n" +
                  "#{add_inx}    a #{CosmicRdf::RDF_CLASS[:transcript_seq]};\n" +
                  "#{add_inx}    rdfs:label  \"#{acc}\";\n" +
                  "#{add_inx}    dct:references <#{CosmicRdf::URIs[:refseq]}#{acc}>\n" +
                  "#{add_inx}  ] ;"
        end
        if acc =~ /^((ENS[A-Z]*[FPTG]\d{11}(\.\d+)?)|(FB\w{2}\d{7})|(Y[A-Z]{2}\d{3}[a-zA-Z](\-[A-Z])?)|([A-Z_a-z0-9]+(\.)?(t)?(\d+)?([a-z])?))$/
           return "#{add_inx}  dct:identifier \"#{acc}\";\n" +
                  "#{add_inx}  dct:references ensembl:#{acc} ;\n"
        end
        return    "  #{@predicate}accession_number \"#{acc}\";" unless acc.nil?
        return nil
      end

      def self.hgnc_relation(hgnc_id)
        if hgnc_id.to_s =~ /^[0-9]+$/
          return  "dct:references hgncurl:#{hgnc_id}"
        end
        return    "  #{@predicate}hgnc #{hgnc_id} ;" unless hgnc_id.nil?
        return nil
      end
      
      def self.sampleid_relation(sample_id)
        if sample_id.to_s =~ /^[0-9]+$/
          return  "  #{@predicate}sample \"COSS#{sample_id}\" ;\n" +
                  "  cosmic:sample sample:#{sample_id} ;"
        end
        return    "  #{@predicate}sample \"#{sample_id}\" ;" unless sample_id.nil?
        return nil
      end

      def self.mutationid_relation(mut_id)
        return nil if mut_id.nil? || mut_id.to_s.empty?

        mut_id.delete!("COSM") unless mut_id =~ /^[0-9]+$/
        return "  med2rdf:variation mutation:#{mut_id} ;"
      end
      
      def self.cosmicgeneid_relation(cosmic_gene_id)
        if cosmic_gene_id.to_s =~ /^[0-9]+$/
          return "  dcat:identifier \"COSG#{cosmic_gene_id}\" ;\n" +
                 "  rdfs:seeAlso <#{CosmicRdf::URIs[:cosmic_search]}COSG#{cosmic_gene_id}>;"
        elsif cosmic_gene_id != nil
          return "  cosmic:cosmic_geneid \"#{cosmic_gene_id}\" ;\n"
        end
        return nil
      end


      def self.sample_relation(id)
        if id.to_s =~ /^[0-9]+$/
          return  "  cosmic:sample sample:#{id} ;\n";
        end
        return nil
      end

      def self.sample_relations(ids)
        ret = ""
        ids.each do |id|
          r = sample_relation(id)
          ret += r unless r == nil
        end
        return ret
      end

      def self.pmid_relation(pmid)
        if pmid.to_s =~ /^[0-9]+$/
          return  "  dct:references pubmed:#{pmid} ;\n"
        end
        return nil
      end

      def self.pmid_relations(ids)
        ret = ""
        ids.each do |id|
          r = pmid_relation(id)
          ret += r unless r == nil
        end
        return ret
     end

      def self.studyid_relation(study_id)
        if study_id.to_s =~ /^[0-9]+$/
          return  "  cosmic:study study:#{study_id} ;\n"
          # return  "  cosmic:study_id \"COSU#{study_id}\" ;\n" +
          #        "  rdfs:seeAlso <#{CosmicRdf::URIs[:study]}#{study_id}>;"
        elsif study_id != nil
          return "  #{@predicate}study_id \"#{study_id}\" ;"
        else
          return nil
        end
      end

      def self.studyid_relations(ids)
        ret = ""
        ids.each do |id|
          r = studyid_relation(id)
          ret += r unless r == nil
        end
        return ret
     end

      def self.tcga_sample_relation(sample_name)
        if sample_name.start_with?("TCGA")
          return  "  cosmic:sample [\n" +
                  "    a #{CosmicRdf::RDF_CLASS[:gene]};\n" +
                  "    #{@predicate}sample_name \"#{sample_name}\";\n" +
                  "    dct:references <#{CosmicRdf::URIs[:cancerDigital]}#{sample_name}>\n" +
                  "  ] ;"
        elsif sample_name != nil
          return "  #{@predicate}sample_name \"#{sample_name}\" ;"
        else 
          return nil
        end
      end

      def self.entrez_id_relation(entrez_id)
        if entrez_id != nil && entrez_id.to_s =~ /^[0-9]+$/
          return  "" +
                  "  cosmic:entrez [\n" +
                  "    a #{CosmicRdf::RDF_CLASS[:entrez]} ;\n" +
                  "    rdfs:label \"Entrez:#{entrez_id}\" ;\n" +
                  "    dct:references <#{CosmicRdf::URIs[:ncbigene]}#{entrez_id}> ;\n" +
                  "    rdfs:seeAlso <#{CosmicRdf::URIs[:genedirect]}#{entrez_id}> ;\n" +
                  "  ] ;"
          # return "  #{@predicate}entrez #{entrez_id} ;\n" +
        end
        return nil
      end

      def self.genomic_position_relation(start_pos, end_pos, ref_list)

        faldo_ref = ref_list.map{|ref| "      faldo:reference \"#{ref}\" ;" }.join("\n")
        return "" +
               "  faldo:location [\n" +
               "    a faldo:Region ;\n" +
               "    faldo:begin [ \n" +
               "      a faldo:ExactPosition ;\n"  +
               "      faldo:position #{start_pos} ;\n" +
                      faldo_ref +"\n" +
               "    ] ;\n" +
               "    faldo:end [ \n" +
               "      a faldo:ExactPosition ;\n"  +
               "      faldo:position #{end_pos} ;\n" +
                      faldo_ref + "\n" +
               "    ] ;\n" +
               "  ] ;\n"
      end

      def self.mutation_nuc(cds_mut)
        if cds_mut =~ /ins([A-Z]+)$/
          return "  med2rdf:alterationAlelle \"#{$1}\" ;"
        elsif cds_mut =~ /del([A-Z]+)$/
          return "  med2rdf:referenceAlelle \"#{$1}\" ;"
        elsif cds_mut =~ /([A-Z]+)>([A-Z]+)$/
          return "  med2rdf:referenceAlelle \"#{$1}\" ;\n" +
                 "  med2rdf:alterationAlelle \"#{$2}\" ;"
        end
      end



      def self.add_info_samples(fout,sample_class)
        @smpl_hash.each_pair do |sample_id, smpl_item|
          rdf_ttl = []
          rdf_ttl << "sample:#{sample_id} \n"+ ## Subject
                     "  dcat:identifier \"COSS#{sample_id}\" ;"
          sample_class.accessors.each do |item|
            smpl_item.send(item).each do |val|
              next if val.nil? || val.to_s.empty?
              next if item == :sample_id
              rdf_ttl << 
              case item
                when :pmid; pmid_relation(val)
                else sample_rdf(item, val)
              end
            end
          end
          # 1-sample data
          rdf_ttl << "."
          fout.puts(rdf_ttl)
        end
      end

      def self.add_info_sample_names(fout, sample_class)
        @smpl_hash.each_pair do |smpl_name, smpl_item|
          rdf_ttl = []
          rdf_ttl << "s:#{smpl_name} \n"  ## Subject
          sample_class.accessors.each do |item|
            smpl_item.send(item).each do |val|
              next if val.nil? || val.to_s.empty?
              next if item == :sample_name
              rdf_ttl << 
              case item
                when :pmid; pmid_relation(val)
                else sample_rdf(item, val)
              end
            end
          end
          # 1-sample data
          rdf_ttl << "."
          fout.puts(rdf_ttl)
        end
      end

      def self.sample_rdf(name, val)
        if val.is_a?(Integer) || val.is_a?(FalseClass) || val.is_a?(TrueClass)
          return "  #{CosmicRdf::PREDICATE_PREFIX[:sample]}#{name} #{val} ;"
        else
          return "  #{@predicate}#{name} \"#{val}\" ;"
        end
      end

      # tsv-obj -> mutation-item.
      def self.set_items(items)
        items.class.accessors.each do |item|
          # puts "#{item} #{@row.send(item)}"
          next if @row.send(item).nil? || @row.send(item).to_s.empty?
          items.send(item) << @row.send(item)
          #items.send(item).sort!
          items.send(item).uniq!
        end
        return items
      end

      # tsv-obj -> mutation-item.
      def self.set_items_no_uniq(items)
        items.class.accessors.each do |item|
          # puts "#{item} #{@row.send(item)}"
          next if @row.send(item).nil? || @row.send(item).to_s.empty?
          items.send(item) << @row.send(item)
          #items.send(item).sort!
          items.send(item).uniq!
        end
        return items
      end

      def self.define_header
        header = <<'EOS'
@prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dcat:    <http://www.w3.org/ns/dcat#> .
@prefix dct:     <http://purl.org/dc/terms/> .
@prefix foaf:    <http://xmlns.com/foaf/0.1/> .
@prefix idot:    <http://identifiers.org/terms#> .
@prefix pubmed:  <http://identifiers.org/pubmed/> .
@prefix obo:     <http://purl.obolibrary.org/obo/> .
@prefix sio:     <http://semanticscience.org/resource/> .
@prefix dbp:     <http://dbpedia.org/page/classes#> .
@prefix med2rdf: <http://med2rdf.org/ontology/med2rdf> .
@prefix faldo:   <http://biohackathon.org/resource/faldo#> .

EOS
      end

      def self.rdf_catalog
        header = <<"EOS"
#{@predicate}
a dcat:Dataset ;
  dcat:title "#{@title}" ;
  rdfs:label "#{@label}" ;
  dcat:keyword "#{@keyword}" ;
  dcat:distribution "#{@distribution}" ;
  dcat:language <http://id.loc.gov/vocabulary/iso639-1/en> ;
.
EOS
      end
    end #- end Class
  end #- end Parser
end #- end CosmicRdf


