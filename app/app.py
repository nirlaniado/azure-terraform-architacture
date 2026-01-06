import os
from flask import Flask, request, jsonify
from dateutil import parser as dtparser

from db import init_db, insert_metric, list_metrics

def parse_time(value: str):
    # Accept:
    # - "Sun Dec 28 20:18:07 JST 2025" (example)
    # - ISO 8601: "2025-12-28T20:18:07+02:00"
    # - Many other common formats
    try:
        return dtparser.parse(value)
    except Exception as e:
        raise ValueError(f"Invalid time format: {value}") from e

def create_app():
    app = Flask(__name__)

    @app.get("/health")
    def health():
        return jsonify({"status": "ok"})

    @app.post("/metrics")
    def create_metric():
        data = request.get_json(force=True, silent=False)

        if not isinstance(data, dict):
            return jsonify({"error": "Body must be a JSON object"}), 400

        name = data.get("name")
        value = data.get("value")
        time_str = data.get("time")

        if not isinstance(name, str) or not name.strip():
            return jsonify({"error": "name must be a non-empty string"}), 400

        try:
            value_num = float(value)
        except Exception:
            return jsonify({"error": "value must be a number"}), 400

        if not isinstance(time_str, str) or not time_str.strip():
            return jsonify({"error": "time must be a non-empty string"}), 400

        try:
            time_dt = parse_time(time_str)
        except ValueError as e:
            return jsonify({"error": str(e)}), 400

        insert_metric(name=name.strip(), value=value_num, time_dt=time_dt)
        return jsonify({"inserted": True}), 201

    @app.get("/metrics")
    def get_metrics():
        limit_raw = request.args.get("limit", "100")
        try:
            limit = max(1, min(500, int(limit_raw)))
        except Exception:
            return jsonify({"error": "limit must be an integer"}), 400

        rows = list_metrics(limit=limit)
        # Rows include datetime -> Flask will serialize to RFC format automatically via jsonify
        return jsonify(rows)

    @app.get("/")
    def root():
        return jsonify({
            "service": "simple_net",
            "endpoints": {
                "POST /metrics": {"name": "string", "value": "number", "time": "date string"},
                "GET /metrics?limit=100": "list latest metrics",
                "GET /health": "healthcheck",
            }
        })

    return app

app = create_app()

if __name__ == "__main__":
    # Create table on boot
    init_db()
    host = os.getenv("APP_HOST", "0.0.0.0")
    port = int(os.getenv("APP_PORT", "5000"))
    app.run(host=host, port=port)
