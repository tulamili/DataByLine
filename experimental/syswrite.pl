#!/usr/bin/perl
use 5.001 ; use strict ; use warnings ; 
use Getopt::Std ; getopts 'b:dt:' , \my%o; 
# use autodie qw[ open ] ; 
sub info_write ( ) ; 
sub info_before ( ) ; 
sub info_after ( ) ;
 
my $loc = $o{b} // 0 ; # 書込み位置 
my $txt = do { my $tmp = $o{t} // '' ; eval qq[qq[$tmp]] } ; 
my $len = length $txt ; 

info_write ; 
exit 0 if $o{d} ; 
die qq[ You needs to give the file names to process as the argument of $0. ] unless @ARGV  ;
open my $FH , '+<' , $ARGV[0] or die qq[ File $ARGV[0] cannot open in "+<" mode.] ;
$SIG{ INT } = sub { close $FH ; exit 130 } ; 

info_before ; 


my $newloc = sysseek $FH , $loc, substr ($o{b},0,1) eq '-'  ? 2 : 0  ; 
my $bytes = syswrite $FH, $txt , $len ; 
print qq[Writing started at $newloc byte position. $bytes bytes have changed.] ;
close $FH ; 

info_after ; 

sub info_write ( ) { 
	print qq[You woud write down $len byte character(s), ] ; 
	print qq[at the byte location of $loc, ] ; 
	print qq[with the byte(s) stream of : ] , join ( " " , (my $tmp = unpack 'H*' , $txt ) =~ m/../g ) , "\n" ; 
}

sub info_before ( ) {
	print qq[ File size of "$ARGV[0]" has been ] , -s $ARGV[0] , qq[ bytes. \n] ; 
}

sub info_after ( ) { 
	print qq[ File size of "$ARGV[0]" now is ] , -s $ARGV[0] , qq[ bytes. \n] ; 
}


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

   -b num ; 書込み位置のバイト位置指定。0始まりのはず。
   -t str : 入力するテキスト。eval qq[qq[$txt]] で解釈されるので、\n や \x{0a} などが指定できる。
   
   -d ; ドライランの指定。実際には書き込まないが、どのような文字列を書き込むかを指定する。

  想定される用途及び開発上の注意点: 
    ファイルの最後に改行文字を付加するのに使えるかも知れない。
    ファイルの伸長はできるが、縮めることはできないようだが、確かだろうか?


=cut 