## meter.nim -- Metrics instruments: counter, gauge, histogram.

{.experimental: "strict_funcs".}

import std/atomics


type
  Counter* = ref object
    name*: string
    value: Atomic[int64]

  Gauge* = ref object
    name*: string
    value: Atomic[int64]  ## stored as int64; divide by 1000 for float

  HistogramBucket* = object
    bound*: float64
    count*: int64

  Histogram* = ref object
    name*: string
    buckets*: seq[HistogramBucket]
    sum*: float64
    count*: int64

proc new_counter*(name: string): Counter =
  result = Counter(name: name)
  result.value.store(0)

proc add*(c: Counter, delta: int64 = 1) =
  discard c.value.fetchAdd(delta)

proc get*(c: Counter): int64 =
  c.value.load()

proc new_gauge*(name: string): Gauge =
  result = Gauge(name: name)
  result.value.store(0)

proc set*(g: Gauge, value: int64) =
  g.value.store(value)

proc get*(g: Gauge): int64 =
  g.value.load()

proc new_histogram*(name: string, bounds: seq[float64]): Histogram =
  var buckets: seq[HistogramBucket]
  for b in bounds:
    buckets.add(HistogramBucket(bound: b, count: 0))
  Histogram(name: name, buckets: buckets)

proc record*(h: var Histogram, value: float64) =
  h.sum += value
  inc h.count
  for i in 0 ..< h.buckets.len:
    if value <= h.buckets[i].bound:
      inc h.buckets[i].count
