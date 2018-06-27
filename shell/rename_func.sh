#!/bin/sh

func_name="agc Autocorr Az_lsp Convolve Dec_gain Dec_lag3 Div_32 Enc_lag3 G_code G_pitch grid Inv_sqrt lag_h lag_l Lag_window Levinson Log2 Lsf_lsp Lsp_Az Lsp_lsf Post_Filter Post_Process Pow2 preemphasis Pre_Process Qua_gain Residu Set_zero slope Syn_filt tabl"
func_name="G_code grid lag_h lag_l slope table"

for i in $func_name;
do
         grep -rn -w $i
        #grep -rn "^[a-z|A-Z]" | grep -w $i
done
exit

for i in $func_name;
do
        grep -rn "^[a-z|A-Z]" | grep -w $i | grep "\.c" | grep \( | grep -v ";" | grep -v "Make"
        inc_file=`grep -rn "^[a-z|A-Z]" | grep -w $i | grep "\.c" | grep \( | grep -v ";" | grep -v "Make" | grep -v "hidden"| awk -F':' 'NR==1{ print $1 }' `
        inc_num=`grep -rn "^[a-z|A-Z]" | grep -w $i | grep "\.c" | grep \( | grep -v ";" | grep -v "Make" |  grep -v "hidden"| awk -F':' 'NR==1{ print $2 }' `
        tag=`grep -rn "^[a-z|A-Z]" | grep -w $i | grep "\.c" | grep \( | grep -v ";" | grep -v "Make" |  grep "hidden"|wc -l`
        if [ "$tag" != "0" ]; then
                continue;
        fi

        if [ "$inc_file" != "" ]; then
                printf "\t%-22s:%s\n"  $i  $inc_file
                grep -w $i $inc_file|grep "^[a-z|A-Z]"
                sed -i "${inc_num}s;$i; vdsp_$i;g" $inc_file
        else
                printf "\t%-22s: no found!\n" $i
        fi
done

for i in $func_name;
do
        grep -rn "^[a-z|A-Z]" | grep -w $i | grep "\.h" | grep \(  | grep -v "Make"
        inc_file=`grep -rn "^[a-z|A-Z]" | grep -w $i | grep "\.h" | grep \( | grep -v "Make" | grep -v "hidden"| awk -F':' 'NR==1{ print $1 }' `
        inc_num=`grep -rn "^[a-z|A-Z]" | grep -w $i | grep "\.h" | grep \( |  grep -v "Make" |  grep -v "hidden"| awk -F':' 'NR==1{ print $2 }' `
        tag=`grep -rn "^[a-z|A-Z]" | grep -w $i | grep "\.h" | grep \( | grep -v "Make" |  grep "hidden"|wc -l`
        if [ "$tag" != "0" ]; then
                continue;
        fi

        if [ "$inc_file" != "" ]; then
                printf "\t%-22s:%s\n"  $i  $inc_file
                grep -w $i $inc_file|grep "^[a-z|A-Z]"
                sed -i "${inc_num}s;$i;vdsp_$i;g" $inc_file
                sed -i "${inc_num}i\#define $i vdsp_$i" $inc_file
        else
                printf "\t%-22s: hhh found!\n" $i
        fi
done
lry |


