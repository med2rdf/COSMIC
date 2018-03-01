#/bin/sh -env bash

set -eu

# FILE_DIR = COSMIC file directory
FILE_DIR='/opt'
cwd=`dirname "${0}"`

# default:/opt
# ruby ${cwd}/bin/file2rdf.rb -d ${FILE_DIR}
ruby ${cwd}/bin/file2rdf.rb