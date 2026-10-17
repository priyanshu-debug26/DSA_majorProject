#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting VeriGraph AI Backend on http://localhost:8000..."
cd "$DIR/backend"
"$DIR/backend/.venv/bin/python" -m uvicorn main:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!

echo "Starting VeriGraph AI Frontend on http://localhost:3001..."
cd "$DIR/frontend"
npm run dev &
FRONTEND_PID=$!

cleanup() {
    echo "Stopping VeriGraph AI services..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
    exit 0
}

trap cleanup SIGINT SIGTERM

echo ""
echo "================================================="
echo " VeriGraph AI is running:"
echo " Frontend: http://localhost:3001"
echo " Backend:  http://localhost:8000"
echo " Docs:     http://localhost:8000/docs"
echo "================================================="
echo "Press Ctrl+C to stop both services."
echo ""

wait
