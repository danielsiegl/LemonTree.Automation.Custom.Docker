#!/usr/bin/env node
/**
 * SVG to PNG conversion using Playwright with Chromium
 * Usage: svg2png <input.svg> <output.png> [width] [height]
 */

const { chromium } = require('/opt/svg2png/node_modules/playwright');
const fs = require('fs');
const path = require('path');

async function svgToPng(svgPath, pngPath, width, height) {
    const svgContent = fs.readFileSync(path.resolve(svgPath), 'utf8');

    // Try to detect dimensions from SVG attributes
    const widthMatch = svgContent.match(/\bwidth=["']?(\d+(?:\.\d+)?)(?:px)?["']?/i);
    const heightMatch = svgContent.match(/\bheight=["']?(\d+(?:\.\d+)?)(?:px)?["']?/i);
    const viewBoxMatch = svgContent.match(/viewBox=["']?\s*[\d.]+\s+[\d.]+\s+([\d.]+)\s+([\d.]+)/i);

    const svgWidth = width
        || (widthMatch ? Math.ceil(parseFloat(widthMatch[1])) : null)
        || (viewBoxMatch ? Math.ceil(parseFloat(viewBoxMatch[1])) : 800);
    const svgHeight = height
        || (heightMatch ? Math.ceil(parseFloat(heightMatch[1])) : null)
        || (viewBoxMatch ? Math.ceil(parseFloat(viewBoxMatch[2])) : 600);

    const browser = await chromium.launch({
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    try {
        const page = await browser.newPage();
        await page.setViewportSize({ width: svgWidth, height: svgHeight });

        const htmlContent = `<!DOCTYPE html>
<html>
<head>
<style>
  * { margin: 0; padding: 0; }
  body { background: transparent; }
</style>
</head>
<body>
<img src="data:image/svg+xml;charset=utf-8,${encodeURIComponent(svgContent)}"
     width="${svgWidth}" height="${svgHeight}" />
</body>
</html>`;

        await page.setContent(htmlContent, { waitUntil: 'networkidle' });
        await page.screenshot({
            path: pngPath,
            clip: { x: 0, y: 0, width: svgWidth, height: svgHeight }
        });

        console.log(`Converted '${svgPath}' to '${pngPath}' (${svgWidth}x${svgHeight})`);
    } finally {
        await browser.close();
    }
}

const args = process.argv.slice(2);
if (args.length < 2) {
    console.error('Usage: svg2png <input.svg> <output.png> [width] [height]');
    console.error('');
    console.error('Arguments:');
    console.error('  input.svg   Path to input SVG file');
    console.error('  output.png  Path to output PNG file');
    console.error('  width       Optional width in pixels (auto-detected from SVG if omitted)');
    console.error('  height      Optional height in pixels (auto-detected from SVG if omitted)');
    process.exit(1);
}

svgToPng(
    args[0],
    args[1],
    args[2] ? parseInt(args[2]) : undefined,
    args[3] ? parseInt(args[3]) : undefined
).catch(err => {
    console.error('Error:', err.message);
    process.exit(1);
});
