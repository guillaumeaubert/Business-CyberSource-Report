#!perl -T

use strict;
use warnings;

use Test::More tests => 17;
use Business::CyberSource::Report;


my $tests =
[
	{
		merchant_id           => 'test_merchant_id',
		username              => 'test_username',
		password              => 'test_password',
		use_production_system => 1,
		test_name             => 'Create a new report factory object (dev).',
		expected_success      => 1,
	},
	{
		merchant_id           => 'test_merchant_id',
		username              => 'test_username',
		password              => 'test_password',
		use_production_system => 0,
		test_name             => 'Create a new report factory object (production).',
		expected_success      => 1,
	},
	{
		merchant_id           => undef,
		username              => 'test_username',
		password              => 'test_password',
		use_production_system => 1,
		test_name             => 'Require defined merchant ID.',
		expected_success      => 0,
	},
	{
		merchant_id           => '',
		username              => 'test_username',
		password              => 'test_password',
		use_production_system => 1,
		test_name             => 'Require non-empty-string merchant ID.',
		expected_success      => 0,
	},
	{
		merchant_id           => 'test_merchant_id',
		username              => 'test_username',
		password              => undef,
		use_production_system => 1,
		test_name             => 'Require defined password.',
		expected_success      => 0,
	},
	{
		merchant_id           => 'test_merchant_id',
		username              => 'test_username',
		password              => '',
		use_production_system => 1,
		test_name             => 'Require non-empty-string password.',
		expected_success      => 0,
	},
	{
		merchant_id           => 'test_merchant_id',
		username              => 'test_username',
		password              => 'test_password',
		test_name             => 'Create a new report factory object without specifying the environment.',
		expected_success      => 1,
	},
];

foreach my $test ( @$tests )
{
	my $merchant_id = delete( $test->{'merchant_id'} );
	my $username = delete( $test->{'username'} );
	my $password = delete( $test->{'password'} );
	my $use_production_system = delete( $test->{'use_production_system'} );
	my $test_name = delete( $test->{'test_name'} );
	my $expected_success = delete( $test->{'expected_success'} );
	
	note ( uc( $test_name ) );
	
	my $report_factory;
	eval
	{
		$report_factory = Business::CyberSource::Report->new(
			merchant_id           => $merchant_id,
			username              => $username,
			password              => $password,
			use_production_system => $use_production_system,
		);
	};
	is(
		$@ ? $@ : 'success',
		$expected_success ? 'success' : $@,
		'Create a new report factory object.',
	);
	
	if ( $expected_success )
	{
		ok(
			defined( $report_factory ),
			'The report factory object is defined.',
		);
		
		ok(
			defined( $report_factory )
			&& $report_factory->isa( 'Business::CyberSource::Report' ),
			'The report factory is an object of the correct type.',
		) || diag( "The object was blessed with >" . ref( $report_factory ) . "<." );
	}
	else
	{
		ok(
			!defined( $report_factory ),
			'No report factory object is returned.',
		);
	}
}
