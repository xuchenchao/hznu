#!/usr/bin/perl
open(FILE,"EIGENVAL");
     for ($i=0;$i<=4;$i++){
         $_=<FILE>;}
     @tmp=split;
     $prefix=$tmp[0];print "$prefix\n";
     $_=<FILE>;
     @tmp=split;
     $NBANDS=$tmp[2]/2;
close(FILE);
$Filled=$ARGV[0];
$Z2Data_File_name="z2_inv$Filled";
$file_name="Z2_out_$prefix"."_filled$Filled.htm";
$a=0.99999999;
@SKP=("(0,0,0)","(&pi;,0,0)","(0,&pi;,0)","(&pi;,&pi;,0)","(0,0,&pi;)","(&pi;,0,&pi;)","(0,&pi;,&pi;)","(&pi;,&pi;,&pi;)");
$band1=$ARGV[0]/2;
$band2=$ARGV[0]/2+1;
$band3=$ARGV[0]/2+2;

system("/public/home/ccxu/z2inv/src/z2inv_vasp.x $Filled > $Z2Data_File_name");
#system(' /public/home/ccxu/easy_script/z2inv_vasp.x $Filled*2 > $Z2Data_File_name');
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
	  print	"          <td align=\"center\"><font face=\"Times New Roman\">TRIM</font></td>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">Parities</font></td>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">&Pi;<sub>$band1</sub></font></td>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">&Pi;<sub>$band2</sub></font></td>\n";
          print "          <td align=\"center\"><font face=\"Times New Roman\">&Pi;<sub>$band3</sub></font></td>\n";
          print "     </tr>\n";

          for($i=0;$i<9;$i++){
               $_=<FILE>;
            }
          for ($j=1;$j<9;$j++){
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
                  print "          <td align=\"center\"><font face=\"Times New Roman\">$band1_sym</font></td>\n";
                  print "          <td align=\"center\"><font face=\"Times New Roman\">$band2_sym</font></td>\n";
                  print "          <td align=\"center\"><font face=\"Times New Roman\">$band3_sym</font></td>\n";
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
        for ($j=1;$j<9;$j++){
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
                      # print "$z2_num \n";
                     
         
         }
       print "for bands below $Filled Z2_num=$z2_num \n";
       close(FILE);
#select STDOUT;
close(WZ2);


