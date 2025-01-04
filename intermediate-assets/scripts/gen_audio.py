#!/usr/bin/env python

import os
import numpy as np
from scipy.io.wavfile import write

AUDIO_RATE = 44100

TARGET = f'{os.getcwd()}/clips'

if not os.path.exists(TARGET):
    os.mkdir(TARGET)


def make_wave(path, length, waveform):
    t = np.linspace(0, length, int(length * AUDIO_RATE), dtype=np.float32)
    data = waveform(t)
    write(f"{TARGET}/{path}", AUDIO_RATE, data)


def make_flat_wave(path, length=1, freq=440):
    make_wave(
        path,
        length,
        lambda t: np.sin(2 * np.pi * freq * t)
    )


def make_pointy_wave(path, length=1, freq=440):
    ramp_up = 0.1
    ramp_down = length - ramp_up

    up = np.linspace(0.0, 1.0, int(ramp_up * AUDIO_RATE), dtype=np.float32)
    down = np.linspace(1.0, 0.0, int(ramp_down*AUDIO_RATE), dtype=np.float32)
    amp = np.concatenate((up, down))

    make_wave(
        path,
        length,
        lambda t: np.multiply(np.sin(2 * np.pi * freq * t), amp)
    )


notes = {
    "c": 16.35,
    "d": 17.32,
    "e": 18.35,
    "f": 21.83,
    "g": 24.5,
    "a": 27.5,
    "b": 30.87
}

for octave in range(9):
    for (note, base) in notes.items():
        freq = base * (2**octave)
        make_flat_wave(
            f"flat-octave{octave-1}-{note}.wav", length=0.5, freq=freq)
        make_pointy_wave(
            f"pointy-octave{octave-1}-{note}.wav", length=0.5, freq=freq)
