#!perl -T

use strict;
use warnings;

use Test::More tests => 1;
use Business::CyberSource::Report::SingleTransaction;

ok(
	Business::CyberSource::Report::SingleTransaction->can( 'retrieve' ),
	'A "retrieve" function exists.',
);