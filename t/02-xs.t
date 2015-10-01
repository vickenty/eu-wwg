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
    use ExtUtils::WeakWrapperGenerator;
    ExtUtils::WeakWrapperGenerator->generate_owned_class("Wrapper::Owned", "Foo", "foo");
    ExtUtils::WeakWrapperGenerator->generate_from_xs({
        xs_package => "Raw",
        parse_xs_name => sub {
            my ($class, $method) = shift =~ /^([^_]+)_(.*)$/;
            return (ucfirst $class, $method);
        },
        package_callback => sub {
            my $package = shift;
            @Bar::ISA = "Wrapper::Owned" if $package eq "Bar";
        },
    }, q!
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
