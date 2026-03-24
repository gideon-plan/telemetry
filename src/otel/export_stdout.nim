## export_stdout.nim -- Stdout JSON exporter for development/debugging.

{.experimental: "strict_funcs".}

import std/[strutils, tables, times]
import span, meter

type
  StdoutExporter* = object
    prefix*: string

proc new_stdout_exporter*(prefix: string = ""): StdoutExporter =
  StdoutExporter(prefix: prefix)

proc format_span*(e: StdoutExporter, s: Span): string =
  ## Format a span as a JSON-like string for stdout.
  var parts: seq[string]
  parts.add("\"trace_id\":\"" & s.trace_id & "\"")
  parts.add("\"span_id\":\"" & s.span_id & "\"")
  if s.parent_span_id.len > 0:
    parts.add("\"parent_span_id\":\"" & s.parent_span_id & "\"")
  parts.add("\"name\":\"" & s.name & "\"")
  parts.add("\"kind\":\"" & $s.kind & "\"")
  parts.add("\"status\":\"" & $s.status & "\"")
  parts.add("\"start_time\":\"" & $s.start_time & "\"")
  parts.add("\"end_time\":\"" & $s.end_time & "\"")
  if s.attributes.len > 0:
    var attrs: seq[string]
    for k, v in s.attributes:
      attrs.add("\"" & k & "\":\"" & v & "\"")
    parts.add("\"attributes\":{" & attrs.join(",") & "}")
  e.prefix & "{" & parts.join(",") & "}"

proc format_counter*(e: StdoutExporter, c: Counter): string =
  e.prefix & "{\"name\":\"" & c.name & "\",\"type\":\"counter\",\"value\":" & $c.get() & "}"

proc format_gauge*(e: StdoutExporter, g: Gauge): string =
  e.prefix & "{\"name\":\"" & g.name & "\",\"type\":\"gauge\",\"value\":" & $g.get() & "}"
