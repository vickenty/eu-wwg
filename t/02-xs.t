use strict;
use warnings;

use Test::More;
use Test::Fatal;

package Raw {
    sub foo_new {
        bless {}, "Foo";
    }

    sub foo_new_bar {
        bless {}, "Bar";
    }

    sub bar_magic {
        42
    }
}

package Wrapper {
    use parent "ExtUtils::WeakWrapperGenerator";
    __PACKAGE__->generate_owned_class("Wrapper::Owned", "Foo", "foo");

    sub init_package {
        my ($self, $package) = @_;

        no strict "refs";
        @{"Bar::ISA"} = "Wrapper::Owned"
            if $package eq "Bar";
    }

    sub parse_xs_name {
        my ($self, $name) = @_;
        return $name =~ /([a-z]+)_(.*)/;
    }

    sub package_for_class {
        my ($self, $class) = @_;
        return ucfirst $class;
    }

    __PACKAGE__->generate_from_xs("Raw", q!
        Foo
        foo_new()
        Bar
        foo_new_bar(foo)
        int
        bar_magic(bar)
    !);
}

my $foo = Foo->new();
can_ok $foo, qw/new_bar/;

my $bar = $foo->new_bar();
can_ok $bar, qw/WRAP BEFORE/;

is $bar->magic(), 42;

$foo = undef;

like exception { $bar->magic() }, qr/object is no longer usable/;

done_testing;
