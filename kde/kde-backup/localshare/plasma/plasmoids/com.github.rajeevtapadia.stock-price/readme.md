# Stock Price Plasmoid (Plasma 6)

Simple Plasma widget showing a stock price and percent change using Yahoo Finance.

## Install (local)
```bash
plasmapkg2 -t plasmoid -i com.github.rajeevtapadia.stock-price
```

To update after changes:
```bash
plasmapkg2 -t plasmoid -u com.github.rajeevtapadia.stock-price
```

Then add the widget from “Add Widgets”.

## Settings
- Symbol (default `^NSEI`)
- Refresh interval in minutes (default 10)

## Notes
- Uses Yahoo Finance chart API (unofficial).
- Colors: green for up, red for down, gray neutral.

