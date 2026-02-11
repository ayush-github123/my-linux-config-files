package main

/*
#cgo pkg-config: libpipewire-0.3
#include "pw_capture.h"

extern void onAudio(int16_t* data, int frames);
*/
import "C"

import (
	"fmt"
	"log"
	"net"
	"sync"
	"unsafe"
)

const (
	SampleRate  = 48000
	Channels    = 2
	FrameMs     = 20
	FrameFrames = SampleRate * FrameMs / 1000
	FrameBytes  = FrameFrames * Channels * 2
)

var (
	conn *net.UDPConn
	mu   sync.Mutex
	buf  = make([]byte, 0, FrameBytes)
)

//export onAudio
func onAudio(data *C.int16_t, frames C.int) {
	samples := unsafe.Slice((*int16)(unsafe.Pointer(data)), int(frames)*Channels)

	mu.Lock()
	for _, s := range samples {
		buf = append(buf, byte(s), byte(s>>8))
		if len(buf) == FrameBytes {
			conn.Write(buf)
			buf = buf[:0]
		}
	}
	mu.Unlock()
}

func main() {
	var address string
	fmt.Print("Enter the IP address: ")
	fmt.Scan(&address)
	remote, err := net.ResolveUDPAddr("udp", address)
	// remote, err := net.ResolveUDPAddr("udp", "192.168.1.45:5002")
	if err != nil {
		log.Fatal(err)
	}

	conn, err = net.DialUDP("udp", nil, remote)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	log.Println("PipeWire capture started →", remote)

	C.pw_start((C.audio_cb_t)(C.onAudio))
}
