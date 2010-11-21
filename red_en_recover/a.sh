for i in {0..11}
do
 if [ $i != 0 ]
 then
     echo "else";
 fi
 echo " if (bit_plane_change==$((4*i))){
	digitalWrite(light,HIGH);
} else if (bit_plane_change==$((4*i+1))){
	digitalWrite(light,LOW);
	digitalWrite(mma,HIGH);
} else if (bit_plane_change==$((4*i+2))){
	digitalWrite(mma,LOW);
}"
done
