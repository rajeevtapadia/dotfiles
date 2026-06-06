// Yahoo Finance fetcher for QML (Plasma)
// Uses plain callbacks — Promises are unreliable in .pragma library QML context.
.pragma library

const YAHOO_API_BASE = "https://query1.finance.yahoo.com/v8/finance/chart/";
const REQUEST_TIMEOUT_MS = 10000;

function lastNonNull(arr) {
    for (var i = arr.length - 1; i >= 0; i--) {
        if (arr[i] !== null && arr[i] !== undefined) return arr[i];
    }
    return null;
}

function firstNonNull(arr) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] !== null && arr[i] !== undefined) return arr[i];
    }
    return null;
}

function parseResponse(json) {
    var result = json.chart && json.chart.result && json.chart.result[0];
    if (!result) {
        var apiErr = json.chart && json.chart.error && json.chart.error.description;
        throw new Error("Invalid data" + (apiErr ? ": " + apiErr : ""));
    }

    var close = result.indicators.quote[0].close;
    var timestamps = result.timestamp;
    var latestPrice = lastNonNull(close);
    var openingPrice = firstNonNull(close);
    var previousClose = result.meta && result.meta.previousClose;

    if (latestPrice === null || previousClose === undefined || openingPrice === null) {
        throw new Error("Incomplete price data");
    }

    var diff = latestPrice - previousClose;
    var latestTimestamp = (timestamps && timestamps.length)
        ? timestamps[timestamps.length - 1] * 1000
        : Date.now();

    return {
        name: result.meta.shortName,
        symbol: result.meta.symbol,
        latest_price: Math.round(latestPrice * 100) / 100,
        opening_price: Math.round(openingPrice * 100) / 100,
        previous_close: Math.round(previousClose * 100) / 100,
        diff: Math.round(diff * 100) / 100,
        diff_percent: Math.round((diff * 10000) / previousClose) / 100,
        latest_time: new Date(latestTimestamp)
    };
}

// Single fetch attempt. Calls onSuccess(data) or onError(errorString).
function fetchPrice(symbol, onSuccess, onError) {
    var xhr = new XMLHttpRequest();
    var url = YAHOO_API_BASE + encodeURIComponent(symbol) + "?interval=5m&range=1d";

    xhr.timeout = REQUEST_TIMEOUT_MS;
    xhr.open("GET", url);
    xhr.setRequestHeader("User-Agent", "Mozilla/5.0");

    xhr.onreadystatechange = function () {
        if (xhr.readyState !== XMLHttpRequest.DONE) return;

        if (xhr.status === 0) {
            onError("Network error (status 0 — no response)");
            return;
        }
        if (xhr.status === 429) {
            onError("Rate limited by Yahoo (HTTP 429)");
            return;
        }
        if (xhr.status !== 200) {
            onError("HTTP " + xhr.status + " from Yahoo Finance");
            return;
        }
        try {
            var data = JSON.parse(xhr.responseText);
            onSuccess(parseResponse(data));
        } catch (e) {
            onError("Parse error: " + (e.message || String(e)));
        }
    };

    xhr.ontimeout = function () {
        onError("Request timed out after " + (REQUEST_TIMEOUT_MS / 1000) + "s");
    };

    xhr.onerror = function () {
        onError("Network error (XHR onerror)");
    };

    xhr.send();
}
