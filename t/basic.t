use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('SessionTest');
$t->get_ok('/auth/login')->content_like(qr/SessionTest Login/i);

done_testing();
