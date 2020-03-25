#!/usr/bin/perl
# Generate all constants from define or enum.

use strict;
use warnings;

sub usage {
    print STDERR "usage: perl script/constant-all.pl\n";
    exit 2;
}

usage() unless @ARGV == 0;

(my $script = $0) =~ s/-all//;
-r $script or die "Cannot read script $script";

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
);

$| = 1;
my $status;
foreach (@consts) {
    print "Get type $$_[0] with prefix $$_[1] in header $$_[2] ...";
    my @cmd = ($^X, $script, @$_);
    system(@cmd);
    print $? ? " failed: $?\n" : " ok\n";
    $status ||= $?;
}
exit($status ? 1 : 0);
