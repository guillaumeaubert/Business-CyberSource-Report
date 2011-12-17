use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name         => 'Business::CyberSource::Report',
	license             => 'artistic',
	dist_author         => q{Guillaume Aubert <aubertg@cpan.org>},
	dist_version_from   => 'lib/Business/CyberSource/Report.pm',
	build_requires      =>
	{
		'HTTP::Request'         => 0,
		'HTTP::Request::Common' => 0,
		'LWP::UserAgent'        => 0,
		'Scalar::Util'          => 0,
		'Test::More'            => 0,
		'XML::LibXML'           => 0,
	},
	requires            =>
	{
		'perl'                  => 5.006,
	},
	add_to_cleanup      =>
	[
		'Business-CyberSource-Report-*',
	],
	create_makefile_pl  => 'traditional',
);

$builder->create_build_script();
