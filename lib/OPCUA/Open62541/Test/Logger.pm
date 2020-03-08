use strict;
use warnings;

package OPCUA::Open62541::Test::Logger;
use Carp;
use POSIX;
use Time::HiRes qw(gettimeofday time sleep);

use Test::More;

sub planning {
    # number of ok(), pass() and fail() calls in this code
    return 3;
}

sub new {
    my $class = shift;
    my $self = { @_ };
    $self->{logger}
	or croak "$class logger not given";

    return bless($self, $class);
}

sub writelog {
    my ($context, $level, $category, $message) = @_;
    $context->printf("%d.%06d %d %s: %s\n",
	gettimeofday(), $level, $category, $message);
    $context->flush();
}

sub file {
    my OPCUA::Open62541::Test::Logger $self = shift;
    my $file = shift;

    ok(open(my $fh, '>', $file), "open log file")
	or return fail "open '$file' for writing failed: $!";
    $self->{logger}->setCallback(\&writelog, $fh, undef);
    pass "set log callback";
    $self->{file} = $file;
}

sub pid {
    my OPCUA::Open62541::Test::Logger $self = shift;
    $self->{pid} = shift if @_;
    return $self->{pid};
}

sub loggrep {
    my OPCUA::Open62541::Test::Logger $self = shift;
    my ($regex, $timeout, $count) = @_;

    my $end;
    $end = time() + $timeout if $timeout;

    do {
	my $kid = waitpid($self->{pid}, WNOHANG);
	if ($kid > 0 && $? != 0) {
	    # child terminated with failure
	    fail "no log grep match, child '$self->{pid}' failed: $?";
	    return;
	}
	open(my $fh, '<', $self->{file}) or
	    return fail "open '$self->{file}' for reading failed: $!";
	my @match = grep { /$regex/ } <$fh>;
	if (!$count && @match or $count && @match >= $count) {
	    pass "log grep match";
	    return wantarray ? @match : $match[0]
	}
	close($fh);
	# pattern not found
	if ($kid == 0) {
	    # child still running, wait for log data
	    sleep .1;
	} else {
	    # child terminated, no new log data possible
	    fail "no log grep match, child '$self->{pid}' terminated";
	    return;
	}
    } while ($timeout and time() < $end);

    fail "no log grep match, timeout '$timeout' reached";
    return;
}

1;

__END__

=head1 NAME

OPCUA::Open62541::Test::Logger - manage open62541 log file for testing

=head1 SYNOPSIS

  use OPCUA::Open62541::Test::Logger;

  my $logger = OPCUA::Open62541::Test::Server->logger();

=head1 DESCRIPTION

Write the output of a server into a log file.
Wait until a given regular expression matches a line in the file.

=head2 METHODS

=over 4

=item $logger = OPCUA::Open62541::Test::Logger->new(%args);

Create a new test logger instance.
Usually called from test server.

=over 8

=item $args{logger}

Required logger instance of the server config.

=back

=item $logger->file($file)

Start writing to log file.

=item $logger->loggrep($regex, $timeout, $count)

Check if regex is present in the log file.
If the process is still alive and a timeout is given, repeat the
check for the number of seconds.
If count is given, wait for this number of matches.
Returns the number of matches.

=item $logger->pid($pid)

Optionally set the id of the process that is writing to log file.
When grepping it will not wait for more input if the process is dead.
Returns the pid.

=back

=head1 SEE ALSO

OPCUA::Open62541,
OPCUA::Open62541::Test::Server

=head1 AUTHORS

Alexander Bluhm E<lt>bluhm@genua.deE<gt>,

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2020 Alexander Bluhm

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

Thanks to genua GmbH, https://www.genua.de/ for sponsoring this work.

=cut
