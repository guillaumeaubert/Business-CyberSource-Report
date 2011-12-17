#!perl -T

use strict;
use warnings;

use Test::More tests => 4;
use Business::CyberSource::Report;


use_ok( 'Business::CyberSource::Report::SingleTransaction' );

my $report_factory = Business::CyberSource::Report->new(
	merchant_id           => 'test_merchant_id',
	username              => 'test_username',
	password              => 'test_password',
	use_production_system => 0,
);

my $report;
eval
{
	$report = $report_factory->build( 'SingleTransaction' )
};
ok(
	!$@ && defined( $report ),
	'Create a SingleTransaction report object.',
) || diag( $@ );

ok(
	$report->isa( 'Business::CyberSource::Report::SingleTransaction' ),
	'The module type is correct.',
) || diag( explain( $report ) );

eval
{
	$report = $report_factory->build( '_invalid_type_' )
};
ok(
	$@,
	'Create a report object of a type that does not exist.',
);
