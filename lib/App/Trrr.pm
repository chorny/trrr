package App::Trrr;

=head1 NAME

App::Trrr - search torrents on CLI

=cut

@ISA = qw(Exporter);
@EXPORT = qw( open_app );
our $VERSION = '0.01';

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

- filter results with as many parameters as needed

- to search torrent filter keywords sa parameters 

C<trrr keyword1 keyword2 keywordN>

- to limit results by minimum number of seeders add number as last parameter

C<trrr keyword1 keyword2 keywordN -100>

- first column is assigned key. To pick a result pres assigned key and it'll be opened in your default torrent client. 

- to pick result from previous search add letter on command line

C<trrr keyword1 keyword2 keywordN -100 -a>

- App::Trr::HotKey is taken from StackOverflow post by brian d foy

=head1 AUTHOR

Zdeněk Bohuněk. E<lt>zdenek@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2016 by Zdeněk Bohuněk 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

