package App::Trrr::Clipboard;


@ISA = qw(Exporter);
@EXPORT = qw( clip );
our $VERSION = '0.02';

use warnings;
use strict;
#use Mac::PropertyList;


sub clip {
    my $os = shift; # read or write
    
    my %clip = (
        ios =>  sub {
            my $data;
            {
                local $/;
                open(my $fh,"<",'/private/var/mobile/Library/Caches/com.apple.UIKit.pboard/pasteboardDB');
                $data = <$fh>;
                close $fh;
            }
            my $mode = shift;
            my $clip = {};
            require Mac::PropertyList;
            Mac::PropertyList->import('parse_plist');

            my $plist = Mac::PropertyList::parse_plist( $data );
            for(@{$plist}){
                my $s = $_->as_perl;
                unless($s eq 1){          
                    if($s->{name} eq 'com.apple.UIKit.pboard.general'){
                        for(@{$s->{items}->{mobile}}){ $clip->{read} = $_->{'public.utf8-plain-text'} }
                    }
                }
            }
            return $clip->{$mode};
        },

        osx =>  sub {
            my $mode = shift;
            my $clip = {};
            $clip->{read} = `pbpaste`; chomp($clip->{read});
            return $clip->{read};
        },
    );
    return $clip{$os};
}

1;
