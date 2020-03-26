#!/usr/bin/perl
# Generate all constants from define or enum.

use strict;
use warnings;

sub usage {
    print STDERR "usage: perl script/constant.pl\n";
    exit 2;
}

usage() unless @ARGV == 0;

# get $VERSION without loading XS code or parsing generated Perl
open(my $fh, '<', "Makefile")
    or die "Open 'Makefile' for reading failed\n";
my $version;
local $_;
while(<$fh>) {
    $version = /^VERSION\s*=\s*(.*)/ and last;
}
close($fh);

# type, prefix, header of generated Perl constants
my @consts = (
  # constants used in define and enum tests
  [qw(	enum	ATTRIBUTEID		constants	)],
  [qw(	define	ACCESSLEVELMASK		constants	)],
  [qw(	define	WRITEMASK		constants	)],
  [qw(	define	VALUERANK		constants	)],
  [qw(	enum	RULEHANDLING		constants	)],
  [qw(	enum	ORDER			constants	)],
  [qw(	enum	VARIANT			types		)],
  # need US_StatusCode as C type to run special typemap conversion
  [qw(	define	StatusCode		statuscodes	)],
  # needed for functionality tests
  [qw(	enum	BROWSERESULTMASK	types_generated	)],
  [qw(	enum	CLIENTSTATE		client_config	)],
  [qw(	enum	NODEIDTYPE		types		)],
  [qw(	define	TYPES			types_generated	)],
  [qw(	define	NS0ID			nodeids		)],
);

parse_consts($version, @consts);

exit(0);

########################################################################
sub parse_consts {
    my ($version, @consts) = @_;

    my $pmfile = "lib/OPCUA/Open62541/Constant.pm";
    open(my $pmf, '>', $pmfile)
	or die "Open '$pmfile' for writing failed: $!";
    my $podfile = "lib/OPCUA/Open62541/Constant.pod";
    open(my $podf, '>', $podfile)
	or die "Open '$podfile' for writing failed: $!";

    print_header($pmf, $version);
    print_pod_header($podf);

    local $_;
    foreach (@consts) {
	parse_prefix($pmf, $podf, @$_);
    }

    print_footer($pmf);
    print_pod_footer($podf);

    close($pmf)
	or die "Close '$pmfile' after writing failed: $!";
    close($podf)
	or die "Close '$podfile' after writing failed: $!";
}

########################################################################
sub parse_prefix {
    my ($pmf, $podf, $type, $prefix, $header) = @_;

    # if prefix is not upper case, it is a typedef, then also create XS file
    my $typedef;
    ($typedef, $prefix) = ($prefix, uc($prefix)) if $prefix ne uc($prefix);

    my $cfile = "/usr/local/include/open62541/$header.h";
    open(my $cf, '<', $cfile)
	or die "Open '$cfile' for reading failed: $!";

    my ($xsfile, $xsf);
    if ($typedef) {
	$xsfile = "Open62541-". lc($typedef). ".xsh";
	open($xsf, '>', $xsfile)
	    or die "Open '$xsfile' for writing failed: $!";
    }

    my $ccomment = qr/\/\*.*?(?:\*\/|$)/;  # C comment /* */, may be multiline
    my $cdefine = qr/#\s*define\s+UA_${prefix}_(\S+)\s+(.+?)/;  # C #define
    my $cenum = qr/UA_${prefix}_([^\s,]+)(?:\s*=\s*([^,]+?))?\s*,?/;  # C enum

    my $regex =
	$type eq 'define' ? qr/^$cdefine\s*$ccomment?\s*$/ :
	$type eq 'enum' ? qr/^\s*$cenum\s*$ccomment?\s*$/ :
	die "Type must be define or enum: $type";

    my (@allstr, $prevnum);
    $prevnum = -1;  # if enum has no value, it starts with 0
    print $podf "=item :$prefix\n\n";
    print $podf "=over 8\n\n";
    while (<$cf>) {
	my ($str, $num) = /$regex/
	    or next;
	# if enum has no value, it increments the previous
	$num //= $prevnum + 1 if $type eq 'enum';
	$num =~ s/(?<=\d)l*u//gi;
	$num = eval "$num";
	my $value = $typedef ? "" : " $num";
	print $pmf "$prefix $str$value\n";
	print $podf "=item ${prefix}_${str}\n\n";
	print_xsfunc($xsf, $typedef, $prefix, $str) if $typedef;
	push @allstr, $str;
	$prevnum = $num;
    }
    print $podf "=back\n\n";
    die "No type $type with prefix $prefix in header $header" unless @allstr;

    if ($xsfile) {
	close($xsf)
	    or die "Close '$xsfile' after writing failed: $!";
    }
}

########################################################################
sub print_header {
    my ($pf, $version) = @_;
    print $pf <<"EOHEADER";
# This file has been generated by $0

package OPCUA::Open62541::Constant;

use 5.015004;
use strict;
use warnings;
use Carp;

our \$VERSION = '$version';

# Even if we declare more than 10k constants, this is a fast way to do it.
my \$consts = <<'EOCONST';
EOHEADER
}

########################################################################
sub print_footer {
    my ($pf) = @_;
    print $pf <<'EOFOOTER';
EOCONST

open(my $fh, '<', \$consts) or croak "open consts: $!";

my %hash;
local $_;
while (<$fh>) {
    chomp;
    my ($prefix, $str, $num) = split;
    $hash{$prefix}{"${prefix}_${str}"} = $num;
}

close($fh) or croak "close consts: $!";

# This is how "use constant ..." creates constants.  constant.pm checks
# constant names and non-existance internally.  We know our names are OK
# and we only declare constants in our own namespace where they don't yet
# exist.  Therefore we can skip the checks and make this module load
# faster.
no strict 'refs';    ## no critic (ProhibitNoStrict)
my $symtab = \%{"OPCUA::Open62541::"};
use strict;

our (@EXPORT_OK, %EXPORT_TAGS);
foreach my $prefix (keys %hash) {
    while (my ($name, $scalar) = each %{$hash{$prefix}}) {
	next unless defined $scalar;  # has typedef, implemented in XS
	Internals::SvREADONLY($scalar, 1);
	$symtab->{$name} = \$scalar;
    }
    push @EXPORT_OK, keys %{$hash{$prefix}};
    $EXPORT_TAGS{$prefix} = [keys %{$hash{$prefix}}];
}
mro::method_changed_in("OPCUA::Open62541");

1;

__END__
EOFOOTER
}

########################################################################
sub print_pod_header {
    my ($pf) = @_;
    print $pf <<"EOPODHEADER";
=pod

=head1 NAME

OPCUA::Open62541::Constant - export constants from open62541 to Perl

=head1 SYNOPSIS

  use OPCUA::Open62541;

  use OPCUA::Open62541 ':all';

  use OPCUA::Open62541 qw(:ATTRIBUTEID ...);

  use OPCUA::Open62541 qw(ORDER_LESS ORDER_EQ ORDER_MORE ...);

=head1 DESCRIPTION

This module provides all defines and enums from open62541 as Perl
constants.
They have been automatically extracted from the C header files.
Do not use this module directly, instead specify the export tag in
OPCUA::Open62541.

=head2 EXPORT

=over 4

=item :all

Export all constants.
You want to import only the ones you need.

EOPODHEADER
}

########################################################################
sub print_pod_footer {
    my ($pf) = @_;
    print $pf <<"EOPODFOOTER";
=back

=head1 SEE ALSO

OPCUA::Open62541

=head1 AUTHORS

Alexander Bluhm,
Arne Becker

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020 Alexander Bluhm

Copyright (c) 2020 Arne Becker

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

Thanks to genua GmbH, https://www.genua.de/ for sponsoring this work.

=cut
EOPODFOOTER
}

########################################################################
sub print_xsfunc {
    my ($xsf, $typedef, $prefix, $str) = @_;
    print $xsf <<"EOXSFUNC";
UA_${typedef}
${prefix}_${str}()
    CODE:
	RETVAL = UA_${prefix}_${str};
    OUTPUT:
	RETVAL

EOXSFUNC
}
