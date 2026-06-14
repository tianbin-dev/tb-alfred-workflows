#!/usr/bin/env node

const crypto = require('crypto');

// 测试函数
function generateSign(q, salt, appId, appKey) {
  return crypto.createHash('md5').update(appId + q + salt + appKey).digest('hex');
}

console.log('测试签名生成:');
console.log(generateSign('Hello, world!', '12345', 'test_app_id', 'test_app_key'));

// 简单的翻译函数测试
async function testTranslate() {
  const url = 'https://fanyi-api.baidu.com/api/trans/vip/translate';

  // 使用测试数据
  const testData = new URLSearchParams({
    q: 'Hello, world!',
    from: 'en',
    to: 'zh',
    appid: 'test_app_id',
    salt: '12345',
    sign: generateSign('Hello, world!', '12345', 'test_app_id', 'test_app_key')
  });

  console.log('\n测试请求参数:');
  console.log(testData.toString());

  try {
    console.log('\n模拟请求 (实际请求需要真实API密钥):');
    console.log(`URL: ${url}`);
    console.log(`Method: POST`);
    console.log(`Content-Type: application/x-www-form-urlencoded`);
  } catch (error) {
    console.error('测试失败:', error);
  }
}

testTranslate();
