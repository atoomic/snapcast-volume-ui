#!/bin/sh

set -e

which cpanm || ( echo "consider runnning 'perlbrew install-cpanm'"; false )

cpanm --installdeps .
