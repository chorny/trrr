use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::Trrr',
    AUTHOR              => 'Zdenek Bohunek <zed448@icloud.com>',
    VERSION_FROM        => 'lib/App/Trrr/HotKey.pm',
    ABSTRACT_FROM       => 'lib/App/Trrr/HotKey.pm',
    PL_FILES            => {},
    'EXE_FILES'         => ['trrr'],
    PREREQ_PM => {
        'HTTP::Tiny'    =>  0,
        'JSON::PP'      =>  0,
        'POSIX'         =>  0,
        'Term::ASCIColor'    =>  0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'iOS-Activator-Listener-Create-*' },
);
