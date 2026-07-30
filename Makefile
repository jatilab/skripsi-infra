TARGET ?= https://skripsi-service-api.afk.web.id/readyz
RATE ?= 10
DURATION ?= 5m

test-load:
	docker run --rm -i --name k6 -e TARGET=$(TARGET) -e RATE=$(RATE) -e DURATION=$(DURATION) grafana/k6 run --summary-trend-stats="avg,p(95),max" - < k6/script.js
