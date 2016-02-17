#!/usr/bin/perl

$E_fermi=`cat ../dos/OUTCAR | grep "E-fermi" | awk '{print \$3}' `;
open(FILE,"EIGENVAL");
     for ($i=0;$i<=4;$i++){
         $_=<FILE>;}
     @tmp=split;
     $prefix=$tmp[0];print "system = $prefix\n";
     $_=<FILE>;
     @tmp=split;
     $num_KP=$tmp[1];print "number of kpoints : $num_KP \n";
     $NBANDS=$tmp[2]/2;
     $_=<FILE>;
     print"Fermi Energy =  $E_fermi";
    #$num_KP=2;
    $filled_band=10000;#$cross_band=0
     for ($i=1;$i<=$num_KP;$i++){
        $_=<FILE>; 
        @tmp=split;
        $kx=$tmp[0];$ky=$tmp[1];$kz=$tmp[2];
       # print "$kx $ky $kz \n";
        $Switch=0; 

         while ( $Switch == 0){   
           $_=<FILE>;
          # print "$j \n";
           @tmp=split;
          # print "$tmp[0]  $tmp[1] $tmp[2] \n";
          if ( ($E_fermi - $tmp[1])<0 ){
             $fill_num=$tmp[0]-1;$Filled_band[$i]=$fill_num;
             if ($fill_num<$filled_band){$filled_band=$fill_num; }
            #if ($cross_band<$fill_num){$cross_band=$fill_num;}
             print "($kx $ky $kz) : bands below $fill_num are all filled \n";
             $Switch=1;
             $skip_num=$NBANDS*2-$fill_num;# print "$skip_num \n";
             for ($j=1;$j<=$skip_num;$j++){
                 $_=<FILE>;
                 }
           } 

           }
     }
   # print "@Filled_band \n";
close(FILE);
$Z2Data_File_name="z2_inv$filled_band";
$file_name="Z2_out_$prefix"."_filled$filled_band.htm";
$a=0.99999999;
if ($num_KP==8){
@SKP=("(0,0,0)","(&pi;,0,0)","(0,&pi;,0)","(&pi;,&pi;,0)","(0,0,&pi;)","(&pi;,0,&pi;)","(0,&pi;,&pi;)","(&pi;,&pi;,&pi;)");
}
if  ($num_KP==4){
@SKP=("(0,0,0)","(&pi;,0,0)","(0,&pi;,0)","(&pi;,&pi;,0)");
}
$band1=($filled_band/2);
$band2=$filled_band/2+1;
$band3=$filled_band/2+2;
system("/public/home/ccxu/z2inv/src/z2inv_vasp.x $filled_band > $Z2Data_File_name");

open (WZ2,">$file_name");
      select WZ2;

       open(FILE,"$Z2Data_File_name");

         print "<html>\n";
         print "<head>\n";
         print "<meta http-equiv=\"Content-Language\" content=\"zh-cn\">\n";
         print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\">\n";
         print "<title>Table S-1</title>\n";
         print "</head>\n";
         print "<body>\n";
          print "<table border=\"1\" width=\"100%\" id=\"table1\" cellspacing=\"0\">\n";
          print "     <tr>\n";
          print "          <td colspan=\"5\"><font face=\"Times New Roman\">Table S-1:</font></td>\n";
          print "     </tr>\n";
          print "     <tr>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">TRIM</font></td>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">Parities</font></td>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">&Pi;<sub>$band1</sub></font></td>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">&Pi;<sub>$band2</sub></font></td>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">&Pi;<sub>$band3</sub></font></td>\n";
          print "     </tr>\n";

          for($i=0;$i<($num_KP+1);$i++){
               $_=<FILE>;
            }
          for ($j=1;$j<($num_KP+1);$j++){
                       $band1_num=1;
                       $band2_num=1;
                       $band3_num=1;
              print "     <tr>\n";
              print "          <td align=\"center\"><font face=\"Times New Roman\">$SKP[$j-1]</font></td>\n";
              print "          <td align=\"center\"><font face=\"Times New Roman\">";
                  for ($i=1;$i<$NBANDS+1;$i++){
                       $_=<FILE>;
                       @tmp=split;
                      if (abs($tmp[2]-1)<1.0){
                        print "+ ";
                        if ($i<=$band1){
                            $band1_num=$band1_num*1;}
                        if ($i<=$band2){
                            $band2_num=$band2_num*1;}
                        if ($i<=$band3){
                            $band3_num=$band3_num*1;}
                       }
                      elsif(abs($tmp[2]+1)<1.0){
                         print "- ";
                        if ($i<=$band1){
                            $band1_num=$band1_num*(-1);}
                        if ($i<=$band2){
                            $band2_num=$band2_num*(-1);}
                        if ($i<=$band3){
                            $band3_num=$band3_num*(-1);}
                        }
                      else {
                         print "x " ;
                        if ($i<=$band1){
                            $band1_num=$band1_num*0;}
                        if ($i<=$band2){
                            $band2_num=$band2_num*0;}
                        if ($i<=$band3){
                            $band3_num=$band3_num*0;}
                         }

                     }
                  if ($band1_num eq 1){$band1_sym = "+";}elsif ($band1_num eq -1){$band1_sym="-";}else{$band1_sym="x";}
                  if ($band2_num eq 1){$band2_sym = "+";}elsif ($band2_num eq -1){$band2_sym="-";}else{$band2_sym="x";}
                  if ($band3_num eq 1){$band3_sym = "+";}elsif ($band3_num eq -1){$band3_sym="-";}else{$band3_sym="x";}
                  print "          </font></td>\n";
                  $a=0;$b=0;$c=0;
                  if ($Filled_band[$j]==($band1*2)){$a=1;}elsif ($Filled_band[$j]==($band2*2) ){$b=1;}elsif($Filled_band[$j]==($band3*2)){$c=1;}
                  if ($a==0){
                         print "          <td align=\"center\"><font face=\"Times New Roman\">$band1_sym</font></td>\n";
                       }
                  else{
                         print "          <td align=\"center\"><font face=\"Times New Roman\" color=\"#FF0000\">$band1_sym</font></td>\n";
                      }
                  if ($b==0){ 
                         print "          <td align=\"center\"><font face=\"Times New Roman\">$band2_sym</font></td>\n";
                      }          
                  else {
                         print "          <td align=\"center\"><font face=\"Times New Roman\" color=\"#FF0000\">$band2_sym</font></td>\n";
                       }
                  if ($c==0){
                         print "          <td align=\"center\"><font face=\"Times New Roman\">$band3_sym</font></td>\n";
                            }
                  else {
                         print "          <td align=\"center\"><font face=\"Times New Roman\" color=\"#FF0000\">$band3_sym</font></td>\n";
                        }
                   print "     </tr>\n";
                  $_=<FILE>;
                  print  "\n";
             }
                  print "</table>\n";
              print "</body>\n";
              print "</html>\n";
select STDOUT;
        print "$_ \n";
        $z2_num=1;
        for ($j=1;$j<($num_KP+1);$j++){
                  $_=<FILE>;
                       @tmp=split;
                    print"@tmp   \n";
                      if (abs($tmp[3]-1) < 1.0){
                        $z2_num=$z2_num*1;
                       }
                      elsif( abs($tmp[3]+1)  < 1.0){
                         $z2_num=$z2_num*(-1);

                        }
                      else {
                         $z2_num=$z2_num*0; }
         }
       print "for bands below $filled_band Z2_num=$z2_num \n";
       close(FILE);
close(WZ2);
