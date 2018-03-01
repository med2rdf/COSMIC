module CosmicRdf
  SFTP_HOST = 'sftp-cancer.sanger.ac.uk'.freeze

  LATEST_VERSION = 82
  AVAILABLE_VERSIONS = [*72..LATEST_VERSION].freeze

  DEFAULT_GRCH = 38
  AVAILABLE_GRCH = [37, DEFAULT_GRCH].freeze

  FILES = {
#    sample:         'CosmicSample.tsv.gz',
#    mutation:       'CosmicMutantExport.tsv.gz',
    # census:         'CosmicMutantExportCensus.tsv.gz',
    # screen:         'CosmicGenomeScreensMutantExport.tsv.gz',
    # target:         'CosmicCompleteTargetedScreensMutantExport.tsv.gz',
#    cna:            'CosmicCompleteCNA.tsv.gz',
#    methylation:    'CosmicCompleteDifferentialMethylation.tsv.gz',
#    ncv:            'CosmicNCV.tsv.gz',
#    resistance:     'CosmicResistanceMutations.tsv.gz',
    fusion:         'CosmicFusionExport.tsv.gz',
    struct:         'CosmicStructExport.tsv.gz',
    breakpoint:     'CosmicBreakpointsExport.tsv.gz',
    hgnc:           'CosmicHGNC.tsv.gz',
    transcript:     'CosmicTranscripts.tsv.gz',
    census:         'cancer_gene_census.csv',
    expression:     'CosmicCompleteGeneExpression.tsv.gz',
    ##ploidy:         'ascat_acf_ploidy.tsv',
    ##fasta:          'All_COSMIC_Genes.fasta.gz',
    ##classification: 'classification.csv',
    ##vcf_coding:     'VCF/CosmicCodingMuts.vcf.gz',
    ##vcf_noncoding:  'VCF/CosmicNonCodingVariants.vcf.gz'
  }.freeze

#  RDF-file name is FILES[] base name...
  RDFS = {
    sample:         'CosmicSample.ttl',
    mutation:       'CosmicMutantExport.ttl',
    #census:         'CosmicMutantExportCensus.ttl',
    #screen:         'CosmicGenomeScreensMutantExport.ttl',
    #target:         'CosmicCompleteTargetedScreensMutantExport.ttl',
    expression:     'CosmicCompleteGeneExpression.ttl',
    cna:            'CosmicCompleteCNA.ttl',
    methylation:    'CosmicCompleteDifferentialMethylation.ttl',
    ncv:            'CosmicNCV.ttl',
    resistance:     'CosmicResistanceMutations.ttl',
    struct:         'CosmicStructExport.ttl',
    breakpoint:     'CosmicBreakpointsExport.ttl',
    fusion:         'CosmicFusionExport.ttl',
    hgnc:           'CosmicHGNC.ttl',
    transcript:     'CosmicTranscripts.ttl',
    census:         'cancer_gene_census.ttl',
  }.freeze

  URIs = {
    sample:        'http://cancer.sanger.ac.uk/cosmic/sample/overview?id=',
    mutation:      'http://cancer.sanger.ac.uk/cosmic/mutation/overview?id=',
    census:        'http://identifiers.org/cosmic/',  ## gene_name
    screen:        'http://med2rdf.org/cosmic/screen#',
    target:        'http://med2rdf.org/cosmic/target#',
    # expression:    'http://med2rdf.org/cosmic/mutation#',
    # expression:    'http://med2rdf.org/cosmic/expressionid#',
    expression:    'http://cancer.sanger.ac.uk/cosmic/sample/overview?id=',
    cna:           'http://cancer.sanger.ac.uk/cosmic/cnv/overview?id=',
    methylation:   'http://med2rdf.org/cosmic/methylation/probeid#',
    ncv:           'http://cancer.sanger.ac.uk/cosmic/ncv/overview?id=',
    resistance:    'http://cancer.sanger.ac.uk/cosmic/mutation/overview?id=',
    struct:        'http://cancer.sanger.ac.uk/cosmic/rearrangement/overview?id=',
    breakpoint:    'http://cancer.sanger.ac.uk/cosmic/rearrangement/overview?id=',
    fusion:        'http://cancer.sanger.ac.uk/cosmic/fusion/summary?id=',
    hgnc:          'http://cancer.sanger.ac.uk/cosmic/gene/analysis?ln=',
    transcript:    'http://identifiers.org/cosmic/',
    genedirect:    'http://cancer.sanger.ac.uk/cosmic/gene/analysis?ln=',
    study:         'http://cancer.sanger.ac.uk/cosmic/study/overview?study_id=',
    cosmiccensus:  'http://cancer.sanger.ac.uk/cosmic/census-page/',
    cosmicncv:     'http://cancer.sanger.ac.uk/cosmic/ncv/overview?id=',
    cancerDigital: 'http://cancer.digitalslidearchive.net/index_mskcc.php?slide_name=',
    cosmicgene:    'http://identifiers.org/cosmic/',
    refseq:        'http://identifiers.org/refseq/',
    hgncurl:       'http://identifiers.org/hgnc/',
    pubmed:        'http://identifiers.org/pubmed/',
    ensembl:       'http://identifiers.org/ensembl/',
    ncbigene:      'http://identifiers.org/ncbigene/',
    nci:           'https://ncit.nci.nih.gov/ncitbrowser/ConceptReport.jsp?dictionary=NCI%20Thesaurus&code=',
    nci_type:      'http://ncicb.nci.nih.gov/xml/owl/EVS/Thesaurus.owl#',
    cosmic_search: 'http://cancer.sanger.ac.uk/cosmic/search?q=',
    sio:           'http://semanticscience.org/resource/'
  }.freeze

  PREFIX = {
    sample:      "@prefix sample:<#{URIs[:sample]}> .",
    mutation:    "@prefix mutation:<#{URIs[:mutation]}> .",
    census:      "@prefix census:<#{URIs[:census]}> .",
    screen:      "@prefix screen:<#{URIs[:screen]}> .",
    target:      "@prefix target:<#{URIs[:target]}> .",
    cna:         "@prefix cna:<#{URIs[:cna]}> .",
    ncv:         "@prefix ncv:<#{URIs[:ncv]}> .",
    fusion:      "@prefix fusion:<#{URIs[:fusion]}> .",
    expression:  "@prefix expression:<#{URIs[:expression]}> .",
    # resistance:  "@prefix resistance:<#{URIs[:resistance]}> .",
    resistance:  "",  ## -> S is  mutation
    methylation: "@prefix methylation:<#{URIs[:methylation]}> .",
    breakpoint:  "@prefix breakpoint:<#{URIs[:breakpoint]}> .",
    study:       "@prefix study:<#{URIs[:study]}> .",
    cosmicncv:   "@prefix cosmicncv:<#{URIs[:cosmicncv]}> .",
    hgnc:        "@prefix hgnc:<#{URIs[:cosmicgene]}> .",
    hgncurl:     "@prefix hgnc:<#{URIs[:hgnc]}> .",
    struct:      "@prefix struct:<#{URIs[:struct]}> .",
    transcript:  "@prefix transcript:<#{URIs[:transcript]}> .",
    cosmicgene:  "@prefix cosmicgene:<#{URIs[:cosmicgene]}> .",
    cosmiccensus:"@prefix cosmiccensus:<#{URIs[:cosmiccensus]}> .",
    ncbigene:    "@prefix ncbigene:<#{URIs[:ncbigene]}> .",
    nci_type:    "@prefix nci:<#{URIs[:nci_type]}> .",
    cosmicname:  "@prefix samplename:<#{URIs[:cosmic_search]}> .",
    sio:         "@prefix sio:<#{URIs[:sio]}> .",
  }.freeze

  PREDICATE_PREFIX = {
    sample:     '@prefix s:<http://med2rdf.org/cosmic/sample#> .',
    mutation:   '@prefix mt:<http://med2rdf.org/cosmic/mutation#> .',
    census:     '@prefix cn:<http://med2rdf.org/cosmic/census#> .',
    screen:     '@prefix sc:<http://med2rdf.org/cosmic/screen#> .',
    target:     '@prefix t:<http://med2rdf.org/cosmic/target#> .',
    cna:        '@prefix c:<http://med2rdf.org/cosmic/cna#> .',
    ncv:        '@prefix n:<http://med2rdf.org/cosmic/ncv#> .',
    fusion:     '@prefix f:<http://med2rdf.org/cosmic/fusion#> .',
    expression: '@prefix e:<http://med2rdf.org/cosmic/expression#> .',
    resistance: '@prefix r:<http://med2rdf.org/cosmic/resistance#> .',
    methylation:'@prefix me:<http://med2rdf.org/cosmic/methylation#> .',
    breakpoint: '@prefix b:<http://med2rdf.org/cosmic/breakpoints#> .',
    hgnc:       '@prefix h:<http://med2rdf.org/cosmic/hgnc#> .',
    struct:     '@prefix st:<http://med2rdf.org/cosmic/struct#> .',
    transcript: '@prefix t:<http://med2rdf.org/cosmic/transcript#> .',
    cosmic:     '@prefix cosmic:<http://med2rdf.org/cosmic/> .',
  }.freeze

  RDF_CLASS = {
    sample:      'a obo:NCIT_C19697 ;',  ##Tissue Sample
    mutation:    'a obo: SO_0001564 ;',   ##gene_variant
    census:      'a obo:NCIT_C19540 ;',  ## 
    screen:      '',
    target:      '',
    cna:         'a obo:SO_0000248 ;',  ## copy_number_variation
    cna_gain:    'a obo:SO_0001742 ;',
    cna_loss:    'a obo:SO_0001743 ;',
    ncv:         'a obo:SO_0001619 ;',  ## non_coding_transcript_variant
    fusion:      'a obo:SO_0001565 ;',  ## fusion
    expression:  'a obo:NCIT_C80488;',
    resistance:  'a obo:NCIT_C102626;',  ## Drug Resistance Status
    methylation: 'a obo:NCIT_C16848 ;',   ## Methylation 
    breakpoint:  'a obo:SO_0000699 ;',   ##  junction
    transcript:  'a med2rdf:Gene ;',
    struct:      'a obo:SO_0001537 ;',
    hgnc:           'obo:NCIT_C100094',
    gene:           'med2rdf:Gene', 
    variation:      'med2rdf:Variation', 
    genome:         'obo:SO_0001026',
    entrez:         'obo:NCIT_C49379',  ## EntrezGene_ID 
    cancer_gene:    'obo:NCIT_C19540',  ## Cancer Gene
    mut_type:       'obo:NCIT_C18093',
    role:           'obo:NCIT_C18669',
    mol_genetics:   'obo:NCIT_C17457',
    tissue:         'obo:SO_0001060',
    transcript_seq: 'obo:SO_0000673',
    study:          'obo:NCIT_C63536',

  }.freeze
end
