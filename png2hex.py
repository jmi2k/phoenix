#!/bin/python3

from PIL import Image
from random import randint
import sys

# Number of values per line
N = 16

image  = Image.open(sys.argv[1])
pixels = image.getdata()
bits   = [format(p, 'x') for p in pixels]
chunks = [bits[i:i+N] for i in range(0, len(bits), N)]
lines  = [' '.join(c) for c in chunks]

print('\n'.join(lines))
