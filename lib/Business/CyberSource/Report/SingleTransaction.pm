package Business::CyberSource::Report::SingleTransaction;

use strict;
use warnings;

use base 'Business::CyberSource::Report';

use HTTP::Request::Common qw();
use LWP::UserAgent qw();


=head1 NAME

Business::CyberSource::Report::SingleTransaction - Interface to CyberSource's
Single Transaction report.


=head1 VERSION

Version 1.1.1

=cut

our $VERSION = '1.1.1';

our $TEST_URL = 'https://ebctest.cybersource.com/ebctest/Query';
our $PRODUCTION_URL = 'https://ebc.cybersource.com/ebc/Query';


=head1 SYNOPSIS

This module is an interface to the Single Transaction report from CyberSource.

	use Business::CyberSource::Report;
	
	# Generate a report factory.
	my $report_factory = Business::CyberSource::Report->new(
		merchant_id => $merchant_id,
		username    => $username,
		password    => $password,
	);
	
	# Build a Business::CyberSource::Report::SingleTransaction object.
	my $single_transaction_report = $report_factory->build( 'SingleTransaction' );
	
	# Retrieve a Single Transaction report by Request ID.
	$single_transaction_report->retrieve(
		request_id              => $request_id,
		include_extended_detail => $include_extended_detail,
		version                 => $version,
	);
	
	# Retrieve a Single Transaction report using a combination of merchant
	# reference number and 
	$single_transaction_report->retrieve(
		merchant_reference_number => $merchant_reference_number,
		target_date               => $target_date,
		include_extended_detail   => $include_extended_detail,
		version                   => $version,
	);

=head1 METHODS


=head2 retrieve()

Build and send the request to CyberSource.

	# Retrieve a Single Transaction report by Request ID.
	$single_transaction_report->retrieve(
		request_id              => $request_id,
		include_extended_detail => $include_extended_detail,
		version                 => $version,
	);
	
	# Retrieve a Single Transaction report using a combination of merchant
	# reference number and target date.
	$single_transaction_report->retrieve(
		merchant_reference_number => $merchant_reference_number,
		target_date               => $target_date,
		include_extended_detail   => $include_extended_detail,
		version                   => $version,
	);

Parameters:

=over

=item *

request_id: a request ID from CyberSource.

=item *

merchant_reference_number/target_date: the reference number you sent with the
original transaction. This is not a number generated by CyberSource. This must
be used in conjunction with a target date, with the format YYYYMMDD.

=item *

include_extended_detail: optional, can be set to 'Predecessor' or 'Related' to
retrieve more information about the transactions found.

=item *

version: CyberSource offers multiple versions of the resulting XML. Available
versions are 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7. By default, it is set to 1.7.
See L<http://apps.cybersource.com/library/documentation/dev_guides/Reporting_Developers_Guide/html/downloading.htm#downloading_10837_1027265>
for more details about the differences.

=back

=cut

sub retrieve
{
	my ( $self, %args ) = @_;
	my $request_id = delete( $args{'request_id'} );
	my $merchant_reference_number = delete( $args{'merchant_reference_number'} );
	my $target_date = delete( $args{'target_date'} );
	
	# Defaults.
	my $include_extended_detail = delete( $args{'include_extended_detail'} );
	my $version = delete( $args{'version'} ) || '1.7';
	
	# Verify the version number.
	die 'The version number can only be 1.1, 1.2, 1.3, 1.4, 1.5, 1.6 or 1.7'
		unless $version =~ m/^1\.[1-7]$/;
	
	# Verify the value of $include_extended_detail.
	if ( defined( $include_extended_detail ) )
	{
		die "The value of 'include_extended_detail' needs to be either 'Predecessor' or 'Related'"
			if $include_extended_detail !~ m/^(Predecessor|Related)$/;
		die "'include_extended_detail' is only available for versions >= 1.3"
			if $version < 1.3;
	}
	
	# Prepare the request parameters.
	my $request_parameters =
	{
		versionNumber => $version,
		merchantID    => $self->get_merchant_id(),
		username      => $self->get_username(),
		password      => $self->get_password(),
		type          => 'transaction',
		subtype       => 'transactionDetail',
	};
	
	# Add the request_id or merchant_reference_number/target_date.
	if ( defined( $request_id ) && !defined( $merchant_reference_number ) && !defined( $target_date ) )
	{
		$request_parameters->{'requestID'} = $request_id;
	}
	elsif ( !defined( $request_id ) && defined( $merchant_reference_number ) && defined( $target_date ) )
	{
		die 'The target_date format must be YYYYMMDD'
			unless $target_date =~ m/^\d{8}$/;
		
		$request_parameters->{'merchantReferenceNumber'} = $merchant_reference_number;
		$request_parameters->{'targetDate'} = $target_date;
	}
	else
	{
		die 'Please provide either a request_id or the combination of a '
			. 'merchant_reference_number and target_date parameters';
	}
	
	# Add option to get extended details.
	$request_parameters->{'includeExtendedDetail'} = $include_extended_detail
		if defined( $include_extended_detail );
	
	# Send the query.
	my $user_agent = LWP::UserAgent->new();
	my $request = HTTP::Request::Common::POST(
		$self->use_production_system() ? $PRODUCTION_URL : $TEST_URL,
		Content => $request_parameters,
	);
	$request->authorization_basic(
		$self->get_username(),
		$self->get_password(),
	);
	
	my $response = $user_agent->request( $request );
	die "Could not get a response from CyberSource"
		unless defined $response;
	die "CyberSource returned the following error: " . $response->status_line()
		unless $response->is_success();
	
	return $response->content();
}


=head1 AUTHOR

Guillaume Aubert, C<< <aubertg at cpan.org> >>.


=head1 BUGS

Please report any bugs or feature requests to C<bug-business-cybersource-report-singletransaction at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=business-cybersource-report-singletransaction>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc Business::CyberSource::Reporting::XML::SingleTransaction


You can also look for information at:

=over 4

=item *

RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=business-cybersource-report-singletransaction>

=item *

AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/business-cybersource-report-singletransaction>

=item *

CPAN Ratings

L<http://cpanratings.perl.org/d/business-cybersource-report-singletransaction>

=item *

Search CPAN

L<http://search.cpan.org/dist/business-cybersource-report-singletransaction/>

=back


=head1 ACKNOWLEDGEMENTS

Thanks to Geeknet, Inc. L<http://www.geek.net> for funding the initial development of this code!


=head1 COPYRIGHT & LICENSE

Copyright 2011 Guillaume Aubert.

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut


1;
