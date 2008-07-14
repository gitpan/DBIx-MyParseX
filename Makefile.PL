use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DBIx::MyParseX',
    AUTHOR              => 'Christopher Brown <ctbrown@cpan.org>',
    VERSION_FROM        => 'lib/DBIx/MyParseX.pm',
    ABSTRACT_FROM       => 'lib/DBIx/MyParseX.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'            => 0 ,
        'DBIx::MyParse'          => 0 ,
        'DBIx::MyParse::Query'   => 0 ,
        'DBIx::MyParse::Item'    => 0 ,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DBIx-MyParseX-*' },
);
