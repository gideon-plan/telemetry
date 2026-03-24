## context.nim -- W3C traceparent header format (trace context propagation).

{.experimental: "strict_funcs".}

import std/strutils
import lattice

type
  TraceContext* = object
    version*: uint8
    trace_id*: string   ## 32 hex chars (16 bytes)
    parent_id*: string  ## 16 hex chars (8 bytes)
    flags*: uint8       ## 0x01 = sampled

proc parse_traceparent*(header: string): Result[TraceContext, OtelError] =
  ## Parse W3C traceparent header: "00-traceid-parentid-flags"
  let parts = header.split('-')
  if parts.len != 4:
    return Result[TraceContext, OtelError].bad(
      OtelError(msg: "invalid traceparent: expected 4 parts, got " & $parts.len))
  if parts[0].len != 2 or parts[1].len != 32 or parts[2].len != 16 or parts[3].len != 2:
    return Result[TraceContext, OtelError].bad(
      OtelError(msg: "invalid traceparent: wrong field lengths"))
  var ctx: TraceContext
  try:
    ctx.version = uint8(parseHexInt(parts[0]))
    ctx.trace_id = parts[1].toLowerAscii()
    ctx.parent_id = parts[2].toLowerAscii()
    ctx.flags = uint8(parseHexInt(parts[3]))
  except ValueError as e:
    return Result[TraceContext, OtelError].bad(OtelError(msg: "invalid traceparent: " & e.msg))
  Result[TraceContext, OtelError].good(ctx)

proc format_traceparent*(ctx: TraceContext): string =
  ## Format W3C traceparent header.
  let ver = toHex(int(ctx.version), 2).toLowerAscii()
  let flags = toHex(int(ctx.flags), 2).toLowerAscii()
  ver & "-" & ctx.trace_id & "-" & ctx.parent_id & "-" & flags

proc is_sampled*(ctx: TraceContext): bool =
  (ctx.flags and 0x01) != 0

proc new_trace_context*(trace_id, parent_id: string, sampled: bool = true): TraceContext =
  TraceContext(version: 0, trace_id: trace_id, parent_id: parent_id,
               flags: if sampled: 0x01 else: 0x00)
