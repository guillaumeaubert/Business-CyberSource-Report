use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name          => 'Business::CyberSource::Report',
	license              => 'GPL_3',
	dist_author          => q{Guillaume Aubert <aubertg@cpan.org>},
	dist_version_from    => 'lib/Business/CyberSource/Report.pm',
	build_requires       =>
	{
		'Carp'                  => 0,
		'Class::Load'           => 0,
		'HTTP::Request'         => 0,
		'HTTP::Request::Common' => 0,
		'LWP::UserAgent'        => 0,
		'Scalar::Util'          => 0,
		'Storable'              => 0,
		'Test::Exception'       => 0,
		'Test::More'            => 0.94,
	},
	requires             =>
	{
		'perl'                  => 5.006,
	},
	add_to_cleanup       =>
	[
		'Business-CyberSource-Report-*',
	],
	create_makefile_pl   => 'traditional',
	recursive_test_files => 1,
	configure_requires   =>
	{
		'Module::Build'         => 0,
	},
	meta_merge           =>
	{
		resources               =>
		{
			repository  => 'https://github.com/guillaumeaubert/Business-CyberSource-Report',
			homepage    => 'https://metacpan.org/release/Business-CyberSource-Report',
			bugtracker  => 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=business-cybersource-report',
		},
	},
);

$builder->create_build_script();
