use strict;
use warnings;
use OPCUA::Open62541;
use Errno;

package OPCUA::Open62541;

use Test::More tests => 15;
use Test::NoWarnings;
use Test::Exception;
use Test::LeakTrace;

my $xs_name = "XS_OPCUA__Open62541_test_croak";

throws_ok { test_croak(undef) } (qr/^$xs_name at /, "croak undef");
throws_ok { test_croak("foo") } (qr/$xs_name: foo at /, "croak foo");
no_leaks_ok { eval { test_croak(undef) } } "leak croak undef";
no_leaks_ok { eval { test_croak("foo") } } "leak croak foo";

$xs_name = "XS_OPCUA__Open62541_test_croake";
$! = Errno::ENOENT;

throws_ok { test_croake(undef, $!) } (qr/^$xs_name: $! at /, "croake undef");
throws_ok { test_croake("foo", $!) } (qr/$xs_name: foo: $! at /, "croake foo");
no_leaks_ok { eval { test_croake(undef) } } "leak croake undef";
no_leaks_ok { eval { test_croake("foo") } } "leak croake foo";

$xs_name = "XS_OPCUA__Open62541_test_croaks";
my $s = STATUSCODE_GOOD;
my $c = 'Good';

throws_ok { test_croaks(undef, $s) } (qr/^$xs_name: $c at /, "croaks undef");
throws_ok { test_croaks("foo", $s) } (qr/$xs_name: foo: $c at /, "croaks foo");
no_leaks_ok { eval { test_croaks(undef, $s) } } "leak croaks undef";
no_leaks_ok { eval { test_croaks("foo", $s) } } "leak croaks foo";

$s = -1;
$c = 'Unknown StatusCode';

throws_ok { test_croaks(undef, $s) } (qr/^$xs_name: $c at /, "croaks unknown");
no_leaks_ok { eval { test_croaks(undef, $s) } } "leak croaks unknown";
