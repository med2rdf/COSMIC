# CosmicRdf

COSMIC RDF Converter

## Description
COSMIC(http://cancer.sanger.ac.uk/cosmic)���_�E�����[�h�\��
�t�@�C������RDF�`���ɕϊ�����X�N���v�g�ł��B

- �Ώۂ̃t�@�C���͈ȉ��̒ʂ�ł��B  
 �i�_�E�����[�h�ɂ�COSMIC�T�C�g�֓o�^���K�v�ł��j  
  CosmicMutantExport.tsv.gz  
  CosmicStructExport.tsv.gz  
  CosmicBreakpointsExport.tsv.gz  
  CosmicFusionExport.tsv.gz  
  CosmicNCV.tsv.gz  
  CosmicCompleteCNA.tsv.gz  
  CosmicCompleteGeneExpression.tsv.gz  
  CosmicCompleteDifferentialMethylation.tsv.gz  
  CosmicSample.tsv.gz  
  CosmicHGNC.tsv.gz  
  CosmicResistanceMutations.tsv.gz  

## Usage

### ����GitHub����擾�����ꍇ
ruby file2rdf.rb -d �m��L�̃t�@�C���̂���f�B���N�g���n 
 -d �ȉ����ȗ�����Ɓm /opt/ �n���Q�Ƃ��A�t�@�C����������΃G���[�I���ƂȂ�܂��B  
  
### Docker �𗘗p����ꍇ�i�b��j  
  Docker�����p�ł�����ňȉ��̃R�}���h�ɂ�莩���I�ɕϊ��X�N���v�g�����s����  
  ���s���I������ƃC���[�W���폜����܂��B  
docker run -v �m��L�̃t�@�C���̂���f�B���N�g���n:/opt/ --hostname cosmicrdf -it --rm genomedianak/cosmic_rdf ruby /root/cosmic_rdf/bin/file2rdf.rb  

�����݂�Docker�őS�Ẵt�@�C����Ώۂɍs���ƁA2���ȏォ����܂��B  
  
