## otel.nim -- OpenTelemetry tracing and metrics. Re-export module.
{.experimental: "strict_funcs".}
import otel/[span, meter, context, export_stdout, export_otlp, lattice]
export span, meter, context, export_stdout, export_otlp, lattice
