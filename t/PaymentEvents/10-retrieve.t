#!perl -T

use strict;
use warnings;

use Business::CyberSource::Report::PaymentEvents;
use Test::FailWarnings -allow_deps => 1;
use Test::More tests => 1;


ok(
	Business::CyberSource::Report::PaymentEvents->can( 'retrieve' ),
	'A "retrieve" function exists.',
);
