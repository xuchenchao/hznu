#!/bin/bash
 
! [ -f EIGENVAL ] && echo "ERROR! NO EIGENVAL" && exit
! [ -f OUTCAR ] && echo "ERROR! NO OUTCAR" && exit
! [ -f KPOINTS ] && echo "ERROR! NO KPOINTS" && exit
! [ -f lab_k ]  && ~/easy_script/vaspbands_modify_advance.pl


#################### fot gnuplot   ##################################
cd ../dos;
Efermi=`cat OUTCAR | grep "E-fermi"| awk '{print $3}'`
#prefix=`cat DOSCAR | head -n 5 | tail -1 | awk '{print $1}'`
LSORBIT=`cat OUTCAR | grep "LSORBIT" | awk '{print $3}'`
[ "$LSORBIT" = "T" ]  && prefix="`cat DOSCAR | head -n 5 | tail -1 | awk '{print $1}'`""_bs_soc" ||  prefix="`cat DOSCAR | head -n 5 | tail -1 | awk '{print $1}'`""_bs_nm"
cd -;
band_energy='$2';
k_points='1';
#lab0='tot-dos'
#lab1='s'
#lab2='p'
#lab3='d'
x_max=`cat lab_k | tail -1 |awk '{print $1}'`
y_min=-2
y_max=2

Xx=($(cat lab_k| awk '{print $1}'))
k_lab_str=""



############### plot  BANDS #######################

> plot.$prefix 
for i in `seq 0 $[${#Xx[@]}-1]`
    do
       printf "
x$i =  ${Xx[$i]}"   >> plot.$prefix 
#lab_kp=`cat KPOINTS | grep "\!" | sed "s/\!//" | uniq |awk '{print $4}' | head -n $[$i+1] | tail -1`
lab_kp=`cat lab_k |awk '{print $2}' | head -n $[$i+1] | tail -1`
    if [ "$lab_kp" = "G" ];then
        k_lab_str="$k_lab_str""\"{/Symbol G}\" ${Xx[$i]},"
    else
         ! [ "$k_lab_str" = "" ]  && k_lab_str="$k_lab_str""\"$lab_kp\" ${Xx[$i]},"
    fi
    done
k_lab_str=${k_lab_str:0:$[${#k_lab_str}-1]}
#echo ${k_lab_str:0:$[${#k_lab_str}-1]}
printf "
unset key
#set style fill  empty border
#set key right top
set xlabel \"K-points\"
set ylabel \"Energy (eV)\"
set xrange[0:$x_max];
unset xtics
set mxtics default
set mytics default
set mxtics 0; 
#set xtics 5;set mxtics 5; 
#set xtics  norangelimit
set yrange[$y_min:$y_max];
set ytics 1;

set arrow from 0.0,0.0 to $x_max,0 nohead lt 3 \n
" >> plot.$prefix

for i in `seq 1 $[${#Xx[@]}-2]`
    do	
	printf "set arrow from ${Xx[$i]},$y_min to ${Xx[$i]},$y_max nohead  linetype 1 linecolor rgb \"black\"  linewidth 1.000 \n" >>  plot.$prefix
    done
printf "
set xtics   ($k_lab_str )
 plot \"bands.dat\" u $k_points : ($band_energy-$Efermi)  w l  

#plot 'bands.dat' u 1:($2)-ef w l t '', 0 lt 2 t ''


set terminal postscript eps color enh
set output \"$prefix.eps\"
#set terminal png
#set output \"dos.png\"
replot " >> plot.$prefix



echo "plot plot.$prefix..."
gnuplot plot.$prefix
rm lab_k
