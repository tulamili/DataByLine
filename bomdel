#!/usr/bin/perl

use 5.001 ; use strict ; use warnings ; 
use Getopt::Std ; getopts '!q' ,\my%o ; 
use Term::ANSIColor qw[ :constants ] ; $Term::ANSIColor::AUTORESET = 1 ; 
$| = 1 if $o{'!'} ;  

my $head = <> ; 
my $bomflag = $head =~ s/^\x{ef}\x{bb}\x{bf}// ; # <-- - UTF-8 の場合　 
print STDERR CYAN 'BOM for UTF-8 ( "ef bb bf" in ASCII ) is detected and prevented to pass. ' . "\n" if $bomflag && ! $o{q} ; 
print $head ; 
print $_ while <> ; 

exit 0 ; 


sub VERSION_MESSAGE {}
sub HELP_MESSAGE {
    use FindBin qw[ $Script ] ; 
    my ($a1,$L,$opt,@out) = ($ARGV[1]//'',0,'^o(p(t(i(o(ns?)?)?)?)?)?$') ;
    open my $FH , '<' , $0 ;
    while(<$FH>){
        s/\$0/$Script/g ;
        $out[$L] .= $_ if s/^=head1\s*(.*)\n/$1/s .. s/^=cut\n//s && ++$L and $a1 =~ /$opt/i ? m/^\s+\-/ : 1 ;
    }
    close $FH ;
    print $ENV{LANG} =~ m/^ja/ ? $out[0] : $out[1] // $out[0] ;
    exit 0 ;
}


=encoding utf8

=head1

  $0

   文字コードがUTF-8の場合の、BOM を取り除く。

 オプション : 
   -! : 出力をバッファに貯めない。
   -q : BOM を検出したことを標準エラー出力に出力しない。

=cut

=head1

  $0 
    Removes the BOM for UTF-8. 

  options :
    -! ; does not use buffer for output. 
    -q ; does not print out to STDERR that BOM is detected. 


=cut
