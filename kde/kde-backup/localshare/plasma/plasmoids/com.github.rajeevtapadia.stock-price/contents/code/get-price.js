// Yahoo Finance fetcher for QML (Plasma)
// Minimal deps: uses XMLHttpRequest available in QML JS
// QML JS does not support ES modules; expose globals instead.
// pragma keeps state shared across imports
// see https://develop.kde.org/docs/plasma/widget/testing/ for testing tips
.pragma library

const YAHOO_API_BASE = "https://query1.finance.yahoo.com/v8/finance/chart/";

function lastNonNull(arr) {
  for (let i = arr.length - 1; i >= 0; i--) {
    if (arr[i] !== null && arr[i] !== undefined) {
      return arr[i];
    }
  }
  return null;
}

function firstNonNull(arr) {
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] !== null && arr[i] !== undefined) {
      return arr[i];
    }
  }
  return null;
}

function parseResponse(json) {
  const result = json.chart && json.chart.result && json.chart.result[0];
  if (!result) {
    throw new Error("Invalid data");
  }

  const close = result.indicators.quote[0].close;
  const timestamps = result.timestamp;

  const latestPrice = lastNonNull(close);
  const openingPrice = firstNonNull(close);
  const previousClose = result.meta && result.meta.previousClose;

  if (latestPrice === null || previousClose === undefined || openingPrice === null) {
    throw new Error("Incomplete price data");
  }

  const diff = latestPrice - previousClose;

  const latestTimestamp = timestamps && timestamps.length
    ? timestamps[timestamps.length - 1] * 1000
    : Date.now();

  return {
    name: result.meta.shortName,
    symbol: result.meta.symbol,
    latest_price: Number(latestPrice.toFixed(2)),
    opening_price: Number(openingPrice.toFixed(2)),
    previous_close: Number(previousClose.toFixed(2)),
    diff: Number(diff.toFixed(2)),
    diff_percent: Number(((diff * 100) / previousClose).toFixed(2)),
    latest_time: new Date(latestTimestamp)
  };
}

function getPrice(symbol) {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    const url =
      YAHOO_API_BASE +
      encodeURIComponent(symbol) +
      "?interval=5m&range=1d";

    xhr.open("GET", url);
    xhr.setRequestHeader("User-Agent", "Plasma Stock Price Widget");
    xhr.onreadystatechange = function () {
      if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status !== 200) {
          reject(new Error("HTTP " + xhr.status));
          return;
        }
        try {
          const data = JSON.parse(xhr.responseText);
          resolve(parseResponse(data));
        } catch (e) {
          reject(e);
        }
      }
    };
    xhr.onerror = function () {
      reject(new Error("Network error"));
    };
    xhr.send();
  });
}

