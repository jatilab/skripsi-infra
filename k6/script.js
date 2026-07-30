import http from 'k6/http';

const TARGET = __ENV.TARGET || 'http://test.k6.io';
const RATE = __ENV.RATE || 5;
const DURATION = __ENV.DURATION || '30s';

export const options = {
  scenarios: {
    probe: {
      executor: 'constant-arrival-rate',
      rate: RATE,
      timeUnit: '1s',
      duration: DURATION,
      preAllocatedVUs: 10,
      maxVUs: 1000
    }
  }
};

export default function () {
  http.get(TARGET, { timeout: '2s' })
}
