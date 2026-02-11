#include "pw_capture.h"

#include <pipewire/pipewire.h>
#include <spa/param/audio/format-utils.h>
#include <spa/param/audio/raw-utils.h>

static struct pw_main_loop *loop;
static struct pw_stream *stream;
static audio_cb_t go_cb;

static void on_process(void *data) {
    struct pw_buffer *b;
    struct spa_buffer *buf;

    if ((b = pw_stream_dequeue_buffer(stream)) == NULL)
        return;

    buf = b->buffer;
    if (buf->datas[0].data == NULL)
        goto done;

    int16_t *samples = buf->datas[0].data;
    uint32_t size = buf->datas[0].chunk->size;

    int frames = size / (sizeof(int16_t) * 2); // s16 stereo

    go_cb(samples, frames);

done:
    pw_stream_queue_buffer(stream, b);
}

static const struct pw_stream_events stream_events = {
    PW_VERSION_STREAM_EVENTS,
    .process = on_process,
};

void pw_start(audio_cb_t cb) {
    go_cb = cb;

    pw_init(NULL, NULL);
    loop = pw_main_loop_new(NULL);

    struct pw_properties *props = pw_properties_new(
        PW_KEY_MEDIA_TYPE, "Audio",
        PW_KEY_MEDIA_CATEGORY, "Capture",
        PW_KEY_MEDIA_ROLE, "Communication",
        NULL);

    stream = pw_stream_new_simple(
        pw_main_loop_get_loop(loop),
        "l2m-capture",
        props,
        &stream_events,
        NULL
    );

    struct spa_audio_info_raw info = {
        .format = SPA_AUDIO_FORMAT_S16,
        .rate = 48000,
        .channels = 2,
        .position = {
            SPA_AUDIO_CHANNEL_FL,
            SPA_AUDIO_CHANNEL_FR
        }
    };

    uint8_t buffer[256];
    struct spa_pod_builder builder = SPA_POD_BUILDER_INIT(buffer, sizeof(buffer));

    const struct spa_pod *params[1];
    params[0] = spa_format_audio_raw_build(
        &builder,
        SPA_PARAM_EnumFormat,
        &info
    );

    pw_stream_connect(
        stream,
        PW_DIRECTION_INPUT,
        PW_ID_ANY,
        PW_STREAM_FLAG_AUTOCONNECT |
        PW_STREAM_FLAG_MAP_BUFFERS |
        PW_STREAM_FLAG_RT_PROCESS,
        params,
        1
    );

    pw_main_loop_run(loop);
}
