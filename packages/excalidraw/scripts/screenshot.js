const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

const EXAMPLES_DIR = path.join(__dirname, '..', 'examples');
const SCREENSHOTS_DIR = path.join(__dirname, '..', 'screenshots');

// Ensure screenshots directory exists
if (!fs.existsSync(SCREENSHOTS_DIR)) {
  fs.mkdirSync(SCREENSHOTS_DIR, { recursive: true });
}

// List of example files to screenshot
const examples = [
  'aws-serverless.excalidraw',
  'microservices-k8s.excalidraw',
  'cicd-pipeline.excalidraw',
  'ecommerce-erd.excalidraw',
  'network-topology.excalidraw'
];

async function takeScreenshots() {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  for (const example of examples) {
    const filePath = path.join(EXAMPLES_DIR, example);

    if (!fs.existsSync(filePath)) {
      console.log(`Skipping ${example} - file not found`);
      continue;
    }

    console.log(`Processing ${example}...`);

    const page = await browser.newPage();
    await page.setViewport({ width: 1920, height: 1080 });

    // Navigate to Excalidraw
    await page.goto('https://excalidraw.com', {
      waitUntil: 'networkidle2',
      timeout: 30000
    });

    // Wait for Excalidraw to load
    await page.waitForSelector('[data-testid="canvas"]', { timeout: 10000 }).catch(() => {
      console.log('Canvas not found by testid, waiting for generic canvas...');
    });

    await new Promise(resolve => setTimeout(resolve, 2000));

    // Read the excalidraw file
    const fileContent = fs.readFileSync(filePath, 'utf8');
    const sceneData = JSON.parse(fileContent);

    // Import the scene using Excalidraw's import functionality
    await page.evaluate((data) => {
      // Create a blob and trigger file import
      const blob = new Blob([JSON.stringify(data)], { type: 'application/json' });
      const file = new File([blob], 'scene.excalidraw', { type: 'application/json' });

      // Create a DataTransfer and dispatch drop event
      const dataTransfer = new DataTransfer();
      dataTransfer.items.add(file);

      const canvas = document.querySelector('canvas');
      if (canvas) {
        const dropEvent = new DragEvent('drop', {
          bubbles: true,
          cancelable: true,
          dataTransfer: dataTransfer
        });
        canvas.dispatchEvent(dropEvent);
      }
    }, sceneData);

    // Wait for the scene to render
    await new Promise(resolve => setTimeout(resolve, 3000));

    // Try to fit the view to content using keyboard shortcut
    await page.keyboard.down('Shift');
    await page.keyboard.press('1');
    await page.keyboard.up('Shift');

    await new Promise(resolve => setTimeout(resolve, 1000));

    // Take screenshot
    const screenshotName = example.replace('.excalidraw', '.png');
    const screenshotPath = path.join(SCREENSHOTS_DIR, screenshotName);

    await page.screenshot({
      path: screenshotPath,
      fullPage: false
    });

    console.log(`Saved: ${screenshotPath}`);
    await page.close();
  }

  await browser.close();
  console.log('All screenshots completed!');
}

takeScreenshots().catch(console.error);
