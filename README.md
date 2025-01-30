# cordova-plugin-deepseek-ai
 

 The DeepSeek API uses an API format compatible with OpenAI. By modifying the configuration, you can use the OpenAI SDK or softwares compatible with the OpenAI API to access the DeepSeek API.

 ### Next release support Gemini API: https://ai.google.dev/gemini-api/docs/downloads

### Video Test plugin https://youtu.be/iE-qwhvBMac

- simple example: https://github.com/EMI-INDO/cordova-plugin-deepseek-ai/blob/main/example
 
<img width="543" alt="cp" src="https://github.com/user-attachments/assets/31eda0e0-03c2-435b-979f-195e0c747496">



- DeepSeek Create API KEY: https://platform.deepseek.com
- OpenAi Create API KEY: https://platform.openai.com

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
- sendRequest
- sendRequestAdvanced
 
- simple example: https://github.com/EMI-INDO/cordova-plugin-deepseek-ai/blob/main/example


### sendRequest
```

          const options = {
           apiUrl: "https://api.deepseek.com/chat/completions", // Replace with the actual API endpoint
           apiKey: "YOUR_API_KEY", // YOUR_API_KEY
           prompt: "hai",
           maxTokens: 100, // 100
           temperature: 0.7, // 0.7
          }

         cordova.plugins.CordovaDeepSeekPlugin.sendRequest(options,
           function(result){

           console.log(JSON.stringify(result))

           }, function(error){

           console.error(error)

           })


```


### sendRequestAdvanced

```
var deepseekOptions = {
        apiUrl: "https://api.deepseek.com/chat/completions", // DeepSeek or OpenAi API request url endpoint
        apiKey: "YOUR_DEEPSEEK_API_KEY",
        model: "deepseek-chat",
        messages: [
            { role: "system", content: "You are a helpful assistant." },
            { role: "user", content: "Hello!" }
        ]
    };

var openAiOptions = {
    apiUrl: "https://api.openai.com/v1/chat/completions",
    apiKey: "sk-your-api-key-here",
    model: "gpt-4o-mini",
    messages: [
        { role: "system", content: "You are a helpful assistant" },
        { role: "user", content: "Hello!" }
    ],
    temperature: 0.7,
    max_tokens: 500,
    top_p: 0.9
};

    cordova.plugins.CordovaDeepSeekPlugin.sendRequestAdvanced(openAiOptions,
    function(response) {
       console.log(JSON.stringify(response))
    }, function(error) {
       console.error(error)
    });

```

### API URL 

> [!NOTE]  
> - Add other api url according to your wishes
- DeepSeek api url:
```
https://api.deepseek.com/chat/completions
```
- OpenAi api url: 
```
https://api.openai.com/v1/chat/completions
```

### Model
> [!NOTE]  
> - Add other models according to your wishes

- DeepSeek Model:
```
deepseek-chat
deepseek-reasoner
```
- OpenAi Model: 
```
gpt-4o
gpt-4
gpt-3.5-turbo
codex
dalle
whisper

```



### New feature requests: 

- Next release support Gemini API: https://ai.google.dev/gemini-api/docs/downloads

[![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/emiindo)  
  [![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/F1F16NI8H)

  ### Support platform: 
  - Android
  - IOS
