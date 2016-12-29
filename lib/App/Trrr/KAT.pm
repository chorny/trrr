package App::Trrr::KAT;

=head1 NAME

App::Trrr::KAT - KickAss API

=cut

@ISA = qw(Exporter);
@EXPORT_OK = qw( kat );
our $VERSION = '0.01';

use 5.010;
use strict;
use URI::Encode qw(uri_decode);
use Carp;
use HTTP::Tiny;

sub kat {
    my @keywords = @_;
    my $url = 'http://kickasstorrents.to/usearch/' . join('%20', @keywords) . '/';

    my $response = HTTP::Tiny->new->get( $url );
    croak "Failed to get $url\n" unless $response->{success};
     
    my( @item, %t ) = ();
    open(my $fh,"<",\$response->{content}) || die "cant open response $!";
    while(<$fh>){
        if(/data-sc-params="\{ 'name'\:/){
            s/(.*\{ 'name': ')(.*?)(\'.*)(magnet\:.*?)('.*)/$2$4/;
            $t{title} = $2; $t{magnet} = $4;
            $t{title} = uri_decode($t{title});
        }
        if(/<td class="nobr center">/){
            $t{size} = $_;
            $t{size} =~ s/(<td class="nobr center">)(.*?)( <span>)(.)(.*)/$2$4/;
            #$t{size} =~ s/(<td class="nobr center">)(.*?)( <span>)(.*?)(<.*)/$2$4/;
        }
        if(/<td class="green center">/){
            $t{seeds} = $_;
            $t{seeds} =~ s/(<td class="green center">)(.*?)(\<.*)/$2/;
        }
        if(/<td class="red lasttd center">/){
            $t{leechs} = $_;
            $t{leechs} =~ s/(<td class="red lasttd center">)(.*?)(\<.*)/$2/;
            $t{category} = 'Video';
            chomp($t{magnet}, $t{title}, $t{size}, $t{category}, $t{seeds}, $t{leechs});
            push @item, {%t};
        }
    }
    return \@item;
}

