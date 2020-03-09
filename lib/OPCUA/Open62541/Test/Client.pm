use strict;
use warnings;

package OPCUA::Open62541::Test::Client;
use OPCUA::Open62541 qw(:statuscode :clientstate);
use Carp 'croak';

use Test::More;

sub planning {
    # number of ok() and is() calls in this code
    return 7;
}

sub new {
    my $class = shift;
    my $self = { @_ };
    $self->{port}
	or croak "no port given";
    $self->{timeout} ||= 10;

    ok($self->{client} = OPCUA::Open62541::Client->new(), "client: new");
    ok($self->{config} = $self->{client}->getConfig(), "client: get config");

    return bless($self, $class);
}

sub url {
    my OPCUA::Open62541::Test::Client $self = shift;
    $self->{url} = shift if @_;
    return $self->{url};
}

sub start {
    my OPCUA::Open62541::Test::Client $self = shift;

    is($self->{config}->setDefault(), "Good", "client: set default config");
    $self->{url} = "opc.tcp://localhost";
    $self->{url} .= ":$self->{port}" if $self->{port};
    return $self;
}

sub run {
    my OPCUA::Open62541::Test::Client $self = shift;

    note("going to connect client to url $self->{url}");
    is($self->{client}->connect($self->{url}), STATUSCODE_GOOD,
	"client: connect");
    is($self->{client}->getState(), CLIENTSTATE_SESSION,
	"client: state session");

    return $self;
}

sub stop {
    my OPCUA::Open62541::Test::Client $self = shift;

    note("going to disconnect client");
    is($self->{client}->disconnect(), STATUSCODE_GOOD, "client: disconnect");
    is($self->{client}->getState, CLIENTSTATE_DISCONNECTED,
	"client: state disconnected");

    return $self;
}

1;

__END__

=head1 NAME

OPCUA::Open62541::Test::Client - run open62541 client for testing

=head1 SYNOPSIS

  use OPCUA::Open62541::Test::Client;
  use Test::More tests => OPCUA::Open62541::Test::Client::planning();

  my $client = OPCUA::Open62541::Test::Client->new();

=head1 DESCRIPTION

In a module test start and run an open62541 OPC UA client that
connects to a server.
The client is considered part of the test and will write to the TAP
stream.

=over 4

=item OPCUA::Open62541::Test::Client::planning

Return the number of tests results that running one client will
create.
Add this to your number of planned tests.

=back

=head2 METHODS

=over 4

=item $client = OPCUA::Open62541::Test::Client->new(%args);

Create a new test client instance.

=over 8

=item $args{port}

Required port number of the server.

=item $args{timeout}

Maximum time the client will run during iterate.
Defaults to 10 seconds.

=back

=item $client->url($url)

Optionally set the url.
Returns the url created from localhost and port.
Must be called after start() for that.

=item $client->start()

Configure the client.

=item $client->run()

Connect the client to the open62541 server.

=item $client->stop()

Disconnect the client from the open62541 server.

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
