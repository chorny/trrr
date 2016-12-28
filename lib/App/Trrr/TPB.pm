package App::Trrr::TPB;

=head1 NAME

App::Trrr::TPB - The PirateBay API

=cut

@ISA = qw(Exporter);
@EXPORT_OK = qw( tpb );
our $VERSION = '0.01';

use strict;
use Carp;
use HTTP::Tinyish;

sub tpb {
    my @keywords = @_;
    my $url = 'https://thepiratebay.org/search/' . join('%20', @keywords) . '/0/99/0';

    my $response = HTTP::Tinyish->new->get( $url );
    croak "Failed to get $url\n" unless $response->{success};
     
    my( @item, %t, $leechs ) = ();
    open(my $fh,"<",\$response->{content}) || die "cant open response $!";
    while(<$fh>){
        if(/detName/){ $t{title} = $_; $t{title} =~ s/(.*?title\=\"Details for )(.*?)(\".*)/$2/ }
        if(/\<a href\=\"magnet/){ $t{magnet} = $_;$t{magnet} =~ s/(\<a href\=\")(magnet.*?)(\".*)/$2/ }
        if(/Size.*?\ /){    $t{size} = $_;$t{size} =~ s/(.*?)(Size.*?\ )(.*?)(\&nbsp\;)(...)(.*)/$3$5/ }
        if(/<td align="right">/){  
            unless($leechs){
                $t{seeds} = $_; $t{seeds} =~ s/(.*?<td align="right">)([0-9]+)(<.*)/$2/; $leechs = 1;
            } else { $t{leechs} = $_; $t{leechs} =~ s/(.*?<td align="right">)([0-9]+)(<.*)/$2/; $leechs = 0 }


        }
                #if(/<td align="right">/){   $t{seeds} = $_; $t{seeds} =~ s/(.*?<td align="right">)([0-9]+)(<.*)/$2/ }
        if(/More from this category/){
            $t{category} = $_;$t{category} =~ s/(.*category\"\>)(.*?)(\<.*)/$2/;
            chomp($t{magnet}, $t{title}, $t{size}, $t{category}, $t{seeds}, $t{leechs});
            push @item, {%t};
            next;
        }
    }
    return \@item;
}

1;

__DATA__
pQuery('tpb.html')->find("a")->each(
    sub { print $_->{href} . ' => ' . $_->{title} . "\n" if $_->{href} =~ /magnet/ }
);
