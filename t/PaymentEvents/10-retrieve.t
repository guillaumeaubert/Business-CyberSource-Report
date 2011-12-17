#!perl -T

use strict;
use warnings;

use Test::More tests => 1;
use Business::CyberSource::Report::PaymentEvents;

ok(
	Business::CyberSource::Report::PaymentEvents->can( 'retrieve' ),
	'A "retrieve" function exists.',
);