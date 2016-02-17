#!/usr/bin/perl
$count_0=0;
$count=0;
open(FILE,"K_PATH");
while(<FILE>)
{
    @tmp=split;
    if ($tmp[4] eq 0){
         $count_0++;
    }
    /\S/ and $count++;
}
close(FILE);

open(FILE,"K_PATH");
$i=0;$cut_path1=0;
    while($_=<FILE>) {   
       @tmp=split;
       $str_temp="$str_temp  $tmp[3]";
       if  ($tmp[4] eq 0){ 
         $_=<FILE>;
         @tmp=split;
         $TEMP[0]=$i*100; $str_condition="$str_condition (\$i eq $TEMP[0]) \|\|";
         $TEMP[1]= "$str_temp|$tmp[3]";
         push @CUT_KPath, [ @TEMP ];
         $str_temp="";
         $cut_path1++;
       }
       if (($. eq $count) && ($cut_path1 eq $count_0))
          {
        if ($count_0 eq 0){$count_0++;}
             $CUT_KPath[$count_0-1][1]="$CUT_KPath[$count_0-1][1]$str_temp";

            }
        $i++;
      
}

#         print "$CUT_KPath[0][1] \n";
#         print "$CUT_KPath[1][1] \n";
#         print "$CUT_KPath[2][1] \n";
#         print "$CUT_KPath[3][1] \n";
#         print "$CUT_KPath[3][0] \n";
#         print "$i\n";
#         print "$str_condition \n";

close(FILE);
$len=length($str_condition);
$str_condition = substr($str_condition,0,$len-2);

for ($i=0;$i<$count_0;$i++){
      $str_K="$str_K$CUT_KPath[$i][1]";
    }
@KPT=split " ",$str_K;


open(FILE, "EIGENVAL");

$_=<FILE>;
@tmp=split;
$nspin=$tmp[3];
for($i=0;$i<4;$i++) {
  $_=<FILE>;
}

$_=<FILE>;
@tmp=split;
$nkpts=$tmp[1];
$nbnds=$tmp[2];

for($i=0;$i<$nkpts;$i++) {
  $_=<FILE>;
  $_=<FILE>;
  for($j=0;$j<$nbnds;$j++) {
    $_=<FILE>;
    @tmp=split;
    if($nspin==1) {
      $te[$j]=$tmp[1];
    }
    else {
      $te[$j*2]=$tmp[1];
      $te[$j*2+1]=$tmp[2];
    }
  }
  push @ebnds, [ @te ];
}

close(FILE);
open (KP,">lab_k");
      select KP;
	   print "0.00000000000000    $KPT[0] \n";
      close(KP);
close(KP);
open(FILE, "OUTCAR");

while($_=<FILE>) {
  if(/k-points in units of 2pi\/SCALE/) {
    $_=<FILE>;
    @kold=split;
    $kpt[0]=0;
    for($i=1;$i<$nkpts;$i++) {
      $_=<FILE>;
      @knew=split;
      if (eval $str_condition ){
           $kpt[$i]=$kpt[$i-1]; 
      }
      else{
      $kpt[$i]=$kpt[$i-1]+sqrt(($knew[0]-$kold[0])**2+($knew[1]-$kold[1])**2+($knew[2]-$kold[2])**2);}
       if(($i%100==0) || ($i==$nkpts-1)){
           open(KP,">>lab_k");
                select KP;
                      print "$kpt[$i] ";
                      if ($i==$nkpts-1) {print " $KPT[$i/100+1] \n";} else {print " $KPT[$i/100] \n";}
                select STDOUT;
           close(KP);
        }
      @kold=@knew;
    }
  }
}
open (bds,">bands.dat");
    select bds;
	for($i=0;$i<$nbnds;$i++) {
	  for($j=0;$j<$nkpts;$j++) {
	    if($nspin==1) {
	      printf("%12.9f  %12.9f\n",$kpt[$j],$ebnds[$j][$i]);
	    }
	    else {
	      printf("%12.9f  %12.9f  %12.9f\n",$kpt[$j],$ebnds[$j][$i*2],$ebnds[$j][$i*2+1]);
	    }
	  }
	  printf("\n");
	}
    select STDOUT;
close(bds);












