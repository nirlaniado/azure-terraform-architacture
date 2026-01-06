import os
import psycopg2
from psycopg2.extras import RealDictCursor

CREATE_TABLE_SQL = """
CREATE TABLE IF NOT EXISTS metrics (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  value DOUBLE PRECISION NOT NULL,
  time TIMESTAMPTZ NOT NULL
);
"""

def get_conn():
    host = os.environ["DB_HOST"]
    port = int(os.getenv("DB_PORT", "5432"))
    dbname = os.environ["DB_NAME"]
    user = os.environ["DB_USER"]
    password = os.environ["DB_PASS"]
    sslmode = os.getenv("DB_SSLMODE", "prefer")

    return psycopg2.connect(
        host=host,
        port=port,
        dbname=dbname,
        user=user,
        password=password,
        sslmode=sslmode,
    )

def init_db():
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(CREATE_TABLE_SQL)
        conn.commit()
    finally:
        conn.close()

def insert_metric(name: str, value: float, time_dt):
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO metrics (name, value, time) VALUES (%s, %s, %s)",
                (name, value, time_dt),
            )
        conn.commit()
    finally:
        conn.close()

def list_metrics(limit: int = 100):
    conn = get_conn()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(
                "SELECT id, name, value, time FROM metrics ORDER BY id DESC LIMIT %s",
                (limit,),
            )
            return cur.fetchall()
    finally:
        conn.close()
