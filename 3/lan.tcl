#initialisation
set ns [new Simulator]

#open the NAM trace file
set nf [open lan.nam w]
$ns namtrace-all $nf

#open the trace file
set nd [open  lan.tr  w]
$ns trace-all $nd

#define a finish procedure
proc finish {} {
	global ns nf nd
	$ns flush-trace
	close $nf
	close $nd
	exec nam lan.nam &
	exit 0
}

# LAN A
set A0 [$ns node]
set A1 [$ns node]
set A2 [$ns node]
set A3 [$ns node]
set A4 [$ns node]


# LAN B
set B0 [$ns node]
set B1 [$ns node]
set B2 [$ns node]
set B3 [$ns node]
set B4 [$ns node]

#create link between the nodes
$ns newLan "$A0 $A1 $A2 $A3 $A4" 0.5Mb 40ms LL Queue/DropTail Mac/Csma/Cd Channel
$ns newLan "$B0 $B1 $B2 $B3 $B4" 0.5Mb 40ms LL Queue/DropTail Mac/Csma/Cd Channel

#p2p
$ns duplex-link $A0 $B0 1Mb 10ms  DropTail

#orientation
$A0 set X_ 30
$A0 set Y_ 20
$A1 set X_ 10
$A1 set Y_ 10
$A2 set X_ 10
$A2 set Y_ 30
$A3 set X_ 20
$A3 set Y_ 10
$A4 set X_ 20
$A4 set Y_ 30

$B0 set X_ 40
$B0 set Y_ 20
$B1 set X_ 50
$B1 set Y_ 10
$B2 set X_ 50
$B2 set Y_ 30
$B3 set X_ 60
$B3 set Y_ 10
$B4 set X_ 60
$B4 set Y_ 30

#setup a tcp connection
set tcp [new Agent/TCP]
$ns attach-agent $A1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $B4 $sink
$ns connect $tcp $sink

$tcp set fid_ 1
$tcp set window_ 8000


#setup a FTP over a tcp connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.1 "$ftp start"
$ns at 5.0 "$ftp stop"
$ns at 5.5 "finish"
$ns run
