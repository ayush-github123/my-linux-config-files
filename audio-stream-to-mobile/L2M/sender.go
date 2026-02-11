package main

// import (
// 	"io"
// 	"log"
// 	"net"
// 	"os"
// 	"time"
// )

// const (
// 	SampleRate = 48000
// 	Channels   = 2
// 	FrameMs    = 20
// 	FrameSize  = SampleRate * FrameMs / 1000 * Channels * 2 // 3840 bytes
// )

// func main() {
// 	// Phone IP + port (REMOTE)
// 	remoteAddr, err := net.ResolveUDPAddr("udp", "192.168.1.45:5002")
// 	if err != nil {
// 		log.Fatal(err)
// 	}

// 	// Dial = sender
// 	conn, err := net.DialUDP("udp", nil, remoteAddr)
// 	if err != nil {
// 		log.Fatal(err)
// 	}
// 	defer conn.Close()

// 	log.Println("Sending audio to", remoteAddr)

// 	ticker := time.NewTicker(time.Millisecond * FrameMs)
// 	defer ticker.Stop()

// 	buf := make([]byte, FrameSize)

// 	for range ticker.C {
// 		// Read exactly 20ms PCM from pw-cat (stdin)
// 		_, err := io.ReadFull(os.Stdin, buf)
// 		if err != nil {
// 			log.Println("stdin read error:", err)
// 			return
// 		}

// 		// Send ONE audio frame
// 		_, err = conn.Write(buf)
// 		if err != nil {
// 			log.Println("UDP write error:", err)
// 			return
// 		}
// 	}
// }
