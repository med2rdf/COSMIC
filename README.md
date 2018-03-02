# CosmicRdf

COSMIC RDF Converter

## Description
COSMIC(http://cancer.sanger.ac.uk/cosmic)よりダウンロード可能な
ファイルからRDF形式に変換するスクリプトです。

- 対象のファイルは以下の通りです。  
 （ダウンロードにはCOSMICサイトへ登録が必要です）  
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

### 直接GitHubから取得した場合
実行環境に必要なgemをインストールします。  
> (Gemfile ファイルが在るディレクトリ) bundle install  
  
ruby file2rdf.rb -d ［上記のファイルのあるディレクトリ］  
 -d 以下を省略すると［ /opt/ ］を参照し、ファイルが無ければエラーとなり対象のファイルはスキップされます。
 
  
### Docker を利用する場合（暫定）  
  Dockerが利用できる環境で以下のコマンドにより自動的に変換スクリプトが実行され実行が終了するとイメージが削除されます。  
> docker run -v ［上記のファイルのあるディレクトリ］:/opt/ --hostname cosmicrdf -it --rm genomedianak/cosmic_rdf ruby /root/cosmic_rdf/bin/file2rdf.rb  

※現在はDockerで全てのファイルを対象に行うと、2日以上かかります。  
  
