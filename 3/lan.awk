BEGIN{
	sizeofpacket = 0
	starttime = 100
	endtime = 0
}
{
	event = $1
	time = $2
	node_id = $3
	pkt_size = $6
	level = $4
	
	if(event == "+" && pkt_size >= 512){
		if(time < starttime){
			starttime = time
		}
	}
	if(event == "r" && pkt_size >= 512){
		if(time > endtime){
			endtime = time
		}
		hdr_size = pkt_size % 512
		pkt_size -= hdr_size
		
		sizeofpacketrec += pkt_size
	}
}
END{
	printf("Start time : %f\nEnd time : %f\n", starttime, endtime)
	printf("Size of packets recieved: %d\n", sizeofpacketrec);
	printf("Avg throughput = %fbps\n", (sizeofpacketrec/(endtime-starttime))*(8))
}
