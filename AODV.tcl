  # Create nodes
    array set node_ {}
    for {set i 0} {$i < $opt(nn)} {incr i} {
        set node_($i) [$ns_ node]
        
        # Set initial positions randomly within the topography
        set x [expr rand() * $opt(x)]
        set y [expr rand() * $opt(y)]
        $node_($i) set X_ $x
        $node_($i) set Y_ $y
        $node_($i) set Z_ 0.0

        # Label the node
        $ns_ at 0.0 "$node_($i) label node$i"
    }

    # Assign random destinations to simulate mobility
    for {set i 0} {$i < $opt(nn)} {incr i} {
        set dest_x [expr rand() * $opt(x)]
        set dest_y [expr rand() * $opt(y)]
        set speed [expr 5 + rand() * 15]  ;# Random speed between 5 and 20
        $ns_ at [expr rand() * 10] "$node_($i) setdest $dest_x $dest_y $speed"
    }

    # Establish communication between nodes
    for {set i 0} {$i < $opt(nn)} {incr i 2} {
        if {$i < $opt(nn) - 1} {
            puts "Creating communication between node $i and node [expr $i + 1]"
            set udp [$ns_ create-connection UDP $node_($i) LossMonitor $node_([expr $i + 1]) 0]
            $udp set fid_ 1
            set cbr [$udp attach-app Traffic/CBR]
            $cbr set packetSize_ 1000    
            $cbr set interopt_ .07
            $ns_ at 0.0 "$cbr start"
            $ns_ at 4.0 "$cbr stop"
        }
