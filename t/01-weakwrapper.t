use strict;
use warnings;

use Test::More;
use Test::Fatal;

require_ok("ExtUtils::WeakWrapperGenerator");

ExtUtils::WeakWrapperGenerator->generate_owned_class("xs_child_t", "xs_parent_t", "parent");

my $parent = bless {}, "xs_parent_t";
my $child = bless {}, "xs_child_t";
can_ok($child, qw/WRAP BEFORE get_parent/);

$child = $child->WRAP($parent);
is $child->get_parent(), $parent;
is exception { $child->BEFORE() }, undef;

$parent = undef;

like exception { $child->BEFORE() }, qr{object is no longer usable};

done_testing;
