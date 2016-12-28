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
    print $response->{content};
    print "\n--------";
     
    my @item = ();
    open(my $fh,"<",\$response->{content}) || die "cant open response $!";
    my %t = ();
    while(<$fh>){
        if(/detName/){ $t{title} = $_; $t{title} =~ s/(.*?title\=\"Details for )(.*?)(\".*)/$2/ }
        if(/\<a href\=\"magnet/){ $t{magnet} = $_;$t{magnet} =~ s/(\<a href\=\")(magnet.*?)(\".*)/$2/ }
        if(/Size.*?\ /){ $t{size} = $_;$t{size} =~ s/(.*?)(Size.*?\ )(.*?)(\&nbsp\;)(...)/$3$5/ }
        if(/More from this category/){
            $t{category} = $_;$t{category} =~ s/(.*category\"\>)(.*?)(\<.*)/$2/;
            chomp($t{magnet}, $t{title}, $t{size}, $t{category});
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
