set style data dots
set nokey
set xrange [0:  8.84626]
#set yrange [ -0.15118 : 14.68910]
set yrange [ 5.6087 : 7.6087]
set arrow from 0.0,6.6087 to 8.84626,6.6087 nohead lt 0
set arrow from  0.80973,  5.6087 to  0.80973,  7.6087 nohead
set arrow from  0.95096,  5.6087 to  0.95096,  7.6087 nohead
set arrow from  1.29778,  5.6087 to  1.29778,  7.6087 nohead
set arrow from  2.18008,  5.6087 to  2.18008,  7.6087 nohead
set arrow from  3.20806,  5.6087 to  3.20806,  7.6087 nohead
set arrow from  3.68539,  5.6087 to  3.68539,  7.6087 nohead
set arrow from  4.81208,  5.6087 to  4.81208,  7.6087 nohead
set arrow from  5.59567,  5.6087 to  5.59567,  7.6087 nohead
set arrow from  6.81746,  5.6087 to  6.81746,  7.6087 nohead
set arrow from  7.85486,  5.6087 to  7.85486,  7.6087 nohead
set xtics (" G "  0.00000," Y "  0.80973," F "  0.95096," L "  1.29778," I "  2.18008," Z "  3.20806," G "  3.68539," X "  4.81208,"Y/M"  5.59567," G "  6.81746,"N/Z"  7.85486," F "  8.84626)

 

#plot "../bands/bands.dat" u ($1)*2*3.1415926536:2 w l lt 1 t '', "wannier90_band.dat" u 1:2 w l lc "0000FF"
plot "../bands/bands.dat" u ($1)*2*3.1415926536:2 w l lt 1 t '', "wannier90_band.dat" u 1:2 w dots lt 3 t ''

set terminal postscript eps color enh
set output "HfAs2_bands_wannier_nm.eps"

#set terminal png
##set output \"dos.png\"
replot 


