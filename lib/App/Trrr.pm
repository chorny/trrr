package App::Trrr;

=head1 NAME

App::Trrr - search torrents on CLI

=cut

@ISA = qw(Exporter);
@EXPORT = qw( open_app );
our $VERSION = '0.06';

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
                ubuntu  => 'xdg-open', # -------use 'firefox' if Ubuntu
                linux   => 'xdg-open', # ------use 'xdg-open if non-ubutnu linux
    };
    # open pipe to 'uname' command and stream output to <$pipe>  filehandle
    if($^O eq 'MSWin32' or $^O eq 'msys'){ system("$url"); return }
    open my $pipe,"-|",'uname -a';
    while(<$pipe>){
        # ----use regex to find os
        if(/iPhone/){ system("$os->{ios} $url") }
        elsif(/Darwin/){ system("$os->{osx} $url") }
        elsif(/Ubuntu/){ system("$os->{ubuntu} $url") }
        #elsif(/Ubuntu/){ system("$os->{ubuntu} $url > /dev/null") }
        elsif(/Linux/){ my $open = $check_xdg->($os->{linux}); system("$open $url") }
        #elsif(/Linux/){ my $open = $check_xdg->($os->{linux}); system("$open $url > /dev/null") }
    }
};

1;
=head1 SYNOPSIS
    
CLI tool to search torrents using extratorrent API, Filters and sorts results which are then mapped to keys. Press the key with assigned letter and it will download and open torrent in your default client.

=head1 USAGE
    
Filter results with as many parameters as needed

C<trrr keyword1 keyword2 keywordN>

Limit results by minimum number of seeders add number as last parameter.

C<trrr keyword1 keyword2 keywordN -100>

Results are displayed, first column contains assigned key of torrent. To pick a result press assigned key and it'll be opened in your default torrent client. As results are sorted by number of seeders most of the time you want to press an A key. 

To pick result from previous search add letter on command line. This is necessary on Windows running 'Git/Bash for Windows' where you have to specify key on CLI upfront.

C<trrr keyword1 keyword2 keywordN -100 -a'>

=head1 AUTHOR

Zdeněk Bohuněk. <zdenek@cpan.org>

App::Trr::HotKey is taken from StackOverflow post by brian d foy

=head1 COPYRIGHT AND LICENSE

Copyright 2016 by Zdenek Bohunek

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
