#!/usr/bin/env node

const alfy = require('alfy');
const crypto = require('crypto');

// 从环境变量获取API密钥
const appId = process.env.BAIDU_APP_ID;
const appKey = process.env.BAIDU_APP_KEY;

if (!appId || !appKey) {
  alfy.output([
    {
      title: '错误',
      subtitle: '请设置BAIDU_APP_ID和BAIDU_APP_KEY环境变量',
      icon: {
        path: alfy.icon ? alfy.icon.error : '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns'
      }
    }
  ]);
  process.exit(1);
}

// 生成百度翻译API签名
function generateSign(q, salt, appId, appKey) {
  return crypto.createHash('md5').update(appId + q + salt + appKey).digest('hex');
}

async function translate(text) {
  try {
    const salt = Date.now().toString();
    const sign = generateSign(text, salt, appId, appKey);

    const response = await alfy.fetch('https://fanyi-api.baidu.com/api/trans/vip/translate', {
      method: 'POST',
      body: new URLSearchParams({
        q: text,
        from: 'en',
        to: 'zh',
        appid: appId,
        salt: salt,
        sign: sign
      }).toString(),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      json: true
    });

    if (response.error_code) {
      throw new Error(response.error_msg || '翻译失败');
    }

    const translation = response.trans_result[0].dst;

    alfy.output([
      {
        title: translation,
        subtitle: '翻译结果',
        arg: translation,
        icon: {
          path: alfy.icon ? alfy.icon.info : '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericQuestionMarkIcon.icns'
        },
        mods: {
          cmd: {
            subtitle: '复制到剪贴板',
            arg: translation
          },
          alt: {
            subtitle: '查看详细信息',
            arg: translation
          }
        }
      }
    ]);
  } catch (error) {
    alfy.output([
      {
        title: '翻译失败',
        subtitle: error.message,
        icon: {
          path: alfy.icon ? alfy.icon.error : '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertStopIcon.icns'
        }
      }
    ]);
  }
}

// 获取用户输入
const input = (alfy.input || '').trim();

if (input) {
  translate(input);
} else {
  alfy.output([
    {
      title: '请输入要翻译的英文文本',
      subtitle: '例如：Hello, world!',
      icon: {
        path: alfy.icon ? alfy.icon.warning : '/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertCautionIcon.icns'
      }
    }
  ]);
}
