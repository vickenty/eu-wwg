use 5.020;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'ExtUtils::WeakWrapperGenerator',
    AUTHOR           => q{Vickenty Fesunov <cpan-extutils@setattr.net>},
    VERSION_FROM     => 'lib/ExtUtils/WeakWrapperGenerator.pm',
    ABSTRACT_FROM    => 'lib/ExtUtils/WeakWrapperGenerator.pm',
    LICENSE          => 'bsd',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.020,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Fatal' => 0,
    },
    PREREQ_PM => {
        'Scalar::Util' => 0,
        'Carp' => 0,
    },
);
