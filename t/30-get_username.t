#!perl -T

use strict;
use warnings;

use Test::More tests => 1;
use Business::CyberSource::Report;


my $report_factory = Business::CyberSource::Report->new(
	merchant_id           => 'test_merchant_id',
	username              => 'test_username',
	password              => 'test_password',
	use_production_system => 0,
);

is(
	$report_factory->get_username(),
	'test_username',
	'Retrieve the username.',
);
