#!perl -T

use strict;
use warnings;

use Business::CyberSource::Report::SingleTransaction;
use Test::FailWarnings -allow_deps => 1;
use Test::More tests => 1;


ok(
	Business::CyberSource::Report::SingleTransaction->can( 'retrieve' ),
	'A "retrieve" function exists.',
);
