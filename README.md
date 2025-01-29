# cordova-plugin-deepseek-ai
 DeepSeek-V3 achieves a significant breakthrough in inference speed over previous models.

 



- Create API KEY: https://platform.deepseek.com

- Installation cordova
```
cordova plugin add cordova-plugin-deepseek-ai
```

- Installation capacitor
```
npm i cordova-plugin-deepseek-ai
```

- NPM: https://www.npmjs.com/package/cordova-plugin-deepseek-ai

### Plugin methode
- simple example: https://github.com/EMI-INDO/cordova-plugin-deepseek-ai/blob/main/example/index.html

```
           cordova.plugins.CordovaDeepSeekPlugin.sendRequest({

           apiUrl: "https://api.deepseek.com/chat/completions", // Replace with the actual API endpoint
           apiKey: "YOUR_API_KEY", // YOUR_API_KEY
           prompt: "hai",
           maxTokens: 100, // 100
           temperature: 0.7, // 0.7

           }, function(result){

           console.log(JSON.stringify(result))

           }, function(error){

           console.error(error)

           })


```


### New feature requests: 

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/emiindo)  
  [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/F1F16NI8H)

  ### Support platform: 
  - Android
  - IOS
