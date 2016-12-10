package App::Trrr::Open;

@ISA = qw(Exporter);
@EXPORT = qw( open_app );

use strict;
# url to be opened
#my $url = 'https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-Package';

# check if xdg-open utility is installed to use on linux
my $check_xdg = sub {
    my $xdg = shift;
    $xdg = `which $xdg` and chomp $xdg;
    if( $xdg =~ /\/xdg-open/ ){
        return $xdg
        } else { return "echo 'xdg-open command not found, cant open '" }
};

sub open_app {
    my $url = shift;
    my $os = {  osx     => 'open', # ----------use 'uiopen' if osx
                ios     => 'uiopen', # --------use 'uiopen' if ios
                ubuntu  => 'firefox', # -------use 'firefox' if Ubuntu
                linux   => 'xdg-open', # ------use 'xdg-open if non-ubutnu linux
    };
    # open pipe to 'uname' command and stream output to <$pipe>  filehandle
    open my $pipe,"-|",'uname -a';
    while(<$pipe>){
        # ----use regex to find os
        if(/iPhone/){ system("$os->{ios} $url") }
        elsif(/Darwin/){ system("$os->{osx} $url") }
        elsif(/Ubuntu/){ system("$os->{ubuntu} $url") }
        elsif(/Linux/){ my $open = $check_xdg->($os->{linux}) . ' ' . $url; system("$open") }
    }
};

1;
