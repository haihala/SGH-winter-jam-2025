#!/usr/bin/env python

import os
import functools
import sys
import numpy as np
from scipy.io.wavfile import write

AUDIO_RATE = 44100

TARGET = f'{os.getcwd()}/clips'

if not os.path.exists(TARGET):
    os.mkdir(TARGET)


def make_wave(length, waveform):
    t = np.linspace(0, length, int(length * AUDIO_RATE), dtype=np.float32)
    return waveform(t)


def make_flat_wave(length=1, freq=440):
    return make_wave(
        length,
        lambda t: np.sin(2 * np.pi * freq * t)
    )


def make_pointy_wave(length=1, freq=440):
    ramp_up = 0.1 * length
    ramp_down = length - ramp_up

    up = np.linspace(0.0, 1.0, int(ramp_up * AUDIO_RATE), dtype=np.float32)
    down = np.linspace(1.0, 0.0, int(ramp_down*AUDIO_RATE), dtype=np.float32)
    amp = np.concatenate((up, down))

    return make_wave(
        length,
        lambda t: np.multiply(np.sin(2 * np.pi * freq * t), amp)
    )


NOTES = {
    "c": 16.35,
    "d": 17.32,
    "e": 18.35,
    "f": 21.83,
    "g": 24.5,
    "a": 27.5,
    "b": 30.87
}


length = float(sys.argv[1])
if sys.argv[2] == "--all":
    for octave in range(9):
        for (note, base) in NOTES.items():
            freq = base * (2**octave)

            flat = make_flat_wave(length, freq)
            path = f"{TARGET}/flat-octave{octave-1}-{note}.wav"
            write(path, AUDIO_RATE, flat)

            pointy = make_pointy_wave(length, freq)
            path = f"{TARGET}/pointy-octave{octave-1}-{note}.wav"
            write(path, AUDIO_RATE, pointy)
else:
    parsed_notes = [
        (
            NOTES[i[0]],
            float(i[1:]),
        )
        for i in sys.argv[2:]
    ]

    frequencies = [
        base * (2**octave)
        for (base, octave) in parsed_notes
    ]

    for path_bit, fun in [
        ('flat', make_flat_wave),
        ('pointy', make_pointy_wave)
    ]:
        data = np.divide(
            functools.reduce(
                np.add,
                [fun(length, freq) for freq in frequencies]
            ),
            len(frequencies)
        )
        path = f"{TARGET}/{path_bit}-{'-'.join(sys.argv[2:])}.wav"
        write(path, AUDIO_RATE, data)
