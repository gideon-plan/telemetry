## export_otlp.nim -- OTLP export over HTTP (stub).
##
## Placeholder for OTLP protobuf serialization + HTTP POST.
## Full implementation requires protobuf codec from binser or dedicated proto module.

{.experimental: "strict_funcs".}

import lattice, span, meter

type
  OtlpExporter* = object
    endpoint*: string  ## e.g. "http://localhost:4318"

proc new_otlp_exporter*(endpoint: string = "http://localhost:4318"): OtlpExporter =
  OtlpExporter(endpoint: endpoint)

proc export_spans*(e: OtlpExporter, spans: seq[Span]): Result[void, OtelError] =
  ## Stub: serialize spans to OTLP protobuf and POST to /v1/traces.
  Result[void, OtelError].bad(OtelError(msg: "OTLP export not yet implemented (requires protobuf codec)"))

proc export_metrics*(e: OtlpExporter, counters: seq[Counter],
                     gauges: seq[Gauge]): Result[void, OtelError] =
  ## Stub: serialize metrics to OTLP protobuf and POST to /v1/metrics.
  Result[void, OtelError].bad(OtelError(msg: "OTLP export not yet implemented (requires protobuf codec)"))
