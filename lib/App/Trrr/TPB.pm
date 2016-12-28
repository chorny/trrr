package App::Trrr::TPB;

=head1 NAME

App::Trrr::TPB - The PirateBay API

=cut

@ISA = qw(Exporter);
@EXPORT_OK = qw( tpb );
our $VERSION = '0.01';

use strict;

use HTTP::Tiny;
use Data::Dumper;

sub tpb {
    my @keywords = @_;

    my $response = HTTP::Tiny->new->get('https://thepiratebay.org/search/' . join('%20', @keywords));
    die "Failed!\n" unless $response->{success};
     
    my @item = ();
    open(my $fh,'<',\$response->{content}) || die "cant open response $!";
    while(<$fh>){
        my %item = ();
        if(/detName/){ 
            $item{title} = $_;
            $item{title} =~ s/(.*title.*?\>)(.*?)(\<\/a)/$2/;
            $item{title} = $2;
        }
        if(/\<a href\=\"magnet/){
            $item{magnet} = $_;
            $item{magnet} =~ s/(\<a href\=\")(magnet.*?)(\".*)/$2/;
            $item{magnet} = $2
        }
        if(/Size.*?\ /){ 
            $item{size} = $_;
            $item{size} =~ s/(.*?)(Size.*?\ )(.*?)(\&nbsp\;)(...)/$3$5/;
            $item{size} = $3 . $5;
        }
        if(/More from this category/){
            $item{category} = $_;
            $item{category} =~ s/(.*category\"\>)(.*?)(\<.*)/$2/;
            $item{category} = $2;
        }
        if(defined $item{magnet} and defined $item{title} and defined $item{size} and defined $item{category}){ 
            push @item, {%item};
            my %item = ();
            next;
        } 
    }
    return \@item;
}

#my @r = @{tpb(@ARGV)};
#print Dumper @r;
1;

__DATA__
pQuery('tpb.html')->find("a")->each(
    sub { print $_->{href} . ' => ' . $_->{title} . "\n" if $_->{href} =~ /magnet/ }
);
