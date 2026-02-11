#pragma once
#include <stdint.h>

typedef void (*audio_cb_t)(const int16_t* data, int frames);

void pw_start(audio_cb_t cb);
