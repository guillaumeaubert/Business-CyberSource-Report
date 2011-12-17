use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name         => 'Business::CyberSource::Report',
	license             => 'perl',
	dist_author         => q{Guillaume Aubert <aubertg@cpan.org>},
	dist_version_from   => 'lib/Business/CyberSource/Report.pm',
	build_requires      =>
	{
		'Test::More'     => 0,
		'XML::LibXML'    => 0,
		'LWP::UserAgent' => 0,
		'HTTP::Request'  => 0,
	},
	requires =>
	{
		'perl' => 5.006,
	},
	add_to_cleanup      => [ 'Business-CyberSource-Report-*' ],
	create_makefile_pl  => 'traditional',
);

$builder->create_build_script();
