const fs = require('fs');
const https = require('https');
const puppeteer = require('puppeteer-extra')

// Add stealth plugin and use defaults (all tricks to hide puppeteer usage)
const StealthPlugin = require('puppeteer-extra-plugin-stealth')
puppeteer.use(StealthPlugin())

async function download() {

    //xvfb-run --auto-servernum --server-args="-screen 2 1366x768x24" node download_vscode_extension.js

    const m_args = [
        '--no-sandbox',
        '--allow-file-access-from-file',
        '--disable-gpu',
        '--disable-dev-shm-usage'
    ];
    // Launch the browser in headless mode and set up a page.
    const browser = await puppeteer.launch({
        executablePath: '/usr/bin/chromium-browser',
        dumpio: false,
        args: m_args,
        headless: false,
        ignoreHTTPSErrors: true,
        defaultViewport: { width: 1200, height: 800, deviceScaleFactor: 2 }
    })

    const page = await browser.newPage();

    await page.setDefaultTimeout(120000);// 2 minutes in milliseconds
    await page.setDefaultNavigationTimeout(120000);// 2 minutes in milliseconds

    try {

        //xvfb-run --auto-servernum --server-args="-screen 2 1366x768x24" node download_vscode_extension.js

        let downloadUrl, response_downloadUrl;
        let fileName;
        let options = {};
        page.on('response', response => {
            if (response.headers()['content-disposition']) {
                let contentDisposition = response.headers()['content-disposition'];
                let fileNameMatch = contentDisposition.match(/filename="(.+?)"/);
                if (fileNameMatch) {
                    fileName = fileNameMatch[1];
                    response_downloadUrl = response.url();
                    console.log(`response 1 fileName = ${fileName}`)
                    console.log(`response 1 response_downloadUrl = ${response_downloadUrl}`)
                    // let file = fs.createWriteStream(fileName);
                    let request = https.get(response_downloadUrl, options, function (response) {
                        console.log(`response.statusCode = ${response.statusCode}`)
                        if (response.statusCode === 200) {
                            let file = fs.createWriteStream('/app/ms-vscode.cpptools-alpine-x64.vsix.gz');
                            response.pipe(file);
                            file.on('finish', () => {
                                file.close();
                            });
                        } else {
                            console.log("response 1 请求下载失败");
                        }
                        response.on('end', () => {
                            if (response.statusCode === 200) {
                                console.log("response 1 文件下载成功");
                            } else {
                                console.log("response 1 文件下载失败");
                            }
                        });
                    }).on('error', function (err) {
                        console.log("response 1 请求发生错误", err);
                    });

                } else {
                    let fileNameMatch = contentDisposition.match(/filename\*=UTF-8''(.+)/);
                    if (fileNameMatch) {
                        fileName = decodeURIComponent(fileNameMatch[1]);
                        response_downloadUrl = response.url();
                        console.log(`response 2 fileName = ${fileName}`)
                        console.log(`response 2 response_downloadUrl = ${response_downloadUrl}`)
                        // let file = fs.createWriteStream(fileName);
                        let request = https.get(response_downloadUrl, options, function (response) {
                            console.log(`response.statusCode = ${response.statusCode}`)
                            if (response.statusCode === 200) {
                                let file = fs.createWriteStream('/app/ms-vscode.cpptools-alpine-x64.vsix.gz');
                                response.pipe(file);
                            } else {
                                console.log("response 2 请求下载失败");
                            }
                            response.on('end', () => {
                                if (response.statusCode === 200) {
                                    console.log("response 2 文件下载成功");
                                } else {
                                    console.log("response 2 文件下载失败");
                                }
                            });
                        }).on('error', function (err) {
                            console.log("response 2 请求发生错误", err);
                        });
                    }
                }
            }
        });
        page.on('request', request => {
            if (request.url().match(/\/vsextensions\/cpptools\/.*\/vspackage\?targetPlatform=alpine-x64$/) && request.method() === 'GET') {
                downloadUrl = request.url();
                console.log(`request downloadUrl = ${downloadUrl}`)
            }
        });

        await page.goto('https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools', { waitUntil: 'networkidle0' });
        const userAgent = await page.evaluate(() => navigator.userAgent);
        // 点击下载按钮
        await page.waitForSelector('.item-details-download-button');
        await page.click('.item-details-download-button');

        // 等待下载按钮出现
        await page.waitForXPath(`//span[contains(text(), "Alpine Linux 64 bit")]`, { timeout: 120000 });
        console.log('等到下载按钮了')
        //使用xpath找到所有包含特定文本的元素
        const element = await page.$x(`//span[contains(text(), "Alpine Linux 64 bit")]`);

        if (element.length > 0) {
            // 点击元素
            await element[0].click();
            console.log(`element.length = ${element.length} 点击元素`)
        }

        
        const cookies = await page.cookies();
        options = {
            headers: {
                'User-Agent': userAgent,
                'Cookie': cookies.map(c => `${c.name}=${c.value}`).join('; ')
            }
        };

        //等待请求
        await page.waitForResponse(response => response.url() == response_downloadUrl, { timeout: 120000 });
        console.log("响应完成了,开始获取文件");

    } catch (e) {
        console.log(`catch error = ${e}`);
    }

    await browser.close();
}

download();
