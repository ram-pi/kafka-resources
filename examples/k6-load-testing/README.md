# k6 load test

## Run

```bash
go install go.k6.io/xk6/cmd/xk6@latest
xk6 build --with github.com/mostafa/xk6-kafka@latest
./k6 run --vus 50 --duration 5s test_script.js
```