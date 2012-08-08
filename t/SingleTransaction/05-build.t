#!perl -T

use strict;
use warnings;

use Test::Exception;
use Test::More tests => 5;

use Business::CyberSource::Report;


# Name of the report module to test.
my $module = 'SingleTransaction';


# Generate a report factory.
isa_ok(
	my $report_factory = Business::CyberSource::Report->new(
		merchant_id           => 'X',
		username              => 'X',
		password              => 'X',
		use_production_system => 0,
	),
	'Business::CyberSource::Report',
	'Report factory',
);

# Use the factory to get a Business::CyberSource::Report::Test object with
# the correct connection parameters.
my $report;
lives_ok(
	sub
	{
		$report = $report_factory->build( $module );
	},
	"Build a $module report.",
);
isa_ok(
	$report,
	"Business::CyberSource::Report::$module",
	"$module report",
);

# Make sure it was registered properly.
ok(
	defined(
		my $reports_loaded = $report_factory->list_loaded()
	),
	'Retrieve the list of loaded reports.',
);
is(
	scalar( grep { $_ eq $module } @{ $reports_loaded || [] } ),
	1,
	"$module is loaded in the factory.",
);
