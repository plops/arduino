for i in {2,5,8,11,14,17,20,23}
do
 echo "else if (bit_plane_change==$((2*i))){
	digitalWrite(light,HIGH);
} else if (bit_plane_change==$((2*i+1))){
	digitalWrite(light,LOW);
	digitalWrite(mma,HIGH);
} else if (bit_plane_change==$((2*i+2)))){
	digitalWrite(mma,LOW);
}"
done
