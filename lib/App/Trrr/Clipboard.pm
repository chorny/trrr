package App::Trrr::Clipboard;

@ISA = qw(Exporter);
@EXPORT_OK = qw( clip );
our $VERSION = '0.03';

use warnings;
use strict;
#use Mac::PropertyList;

sub os {
    open my $pipe,"-|",'uname -a';
        while(<$pipe>){
            if(/iPhone/){ return 'iPhone' }
            else { return $^O }
        }
}
my $os = os();

sub tool {
    my $tool = {
        linux   => [ 'xsel', 'xclip' ],
        iPhone	=> [ 'pbpaste', 'Mac::PropertyList' ],
        darwin  => [ 'pbpaste', 'pbcopy' ],
        msys    => [ '/dev/clipboard' ],
    };
    for( @{$tool->{$os}} ){ return $_ if `which $_` }
}

sub clip {
    my $tool = tool();
    my $clip = sub {
        #my $clip = {
        #linux =>  sub{ 
            #linux =>  sub{ 
            my $string = shift || undef;
            unless( $string ){ my $read = `$tool`; chomp($read); return $read }
            else { return system("echo $string | $tool") }
            #},
    };
    return $clip;
    #return $clip->{$os};
};









# ----------------------------

=head1 create clipboard

my $c = clip();

=head1 read from clipboard

print $c->();

=head1 write to clipboard

#print $c->('ZDENEK')

=cut
