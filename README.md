# Nvim, Ay?

> That's a cool name, AY? nvimai. Nvim, Ay? Whatever.

It's a plugin made to help with an AI addiction. Now we can code confidently knowing that at every moment we can go for the quick `:NAI tell me how the universe was created` to calm ourselves down a bit. Definitely being serious there. At it's current state the plugin can be used to communicate with openai and ollama models running locally. You can switch between these two by altering the config. You can also pick specific models, set token limits,.

https://github.com/ZirixCZ/nvimai/assets/49836430/ffc4940e-07d9-4229-81c1-3727b017495f

## I want it ay!

Alrighty, let's firstly decide if we want to run an ollama model locally or pay for the openai API. The Installation step is the same regardless of which you want to use. After installation choose either Ollama or OpenAI (or both!).

### Installation
The plugin can be installed with your package manager of choice. Below there's an example of using Lazy, but Plug or Packer shouldn't be too different.

```lua
-- Using lazy
{
    "ZirixCZ/nvimai",
    opts = {
      integration = "openai",
      openai = {
        model = "gpt-3.5-turbo-0125",
        max_tokens = 100,
      },
      ollama = {
        model = "llama2",
      },
    },
  },
```

##### Ollama
If you decide to run models locally with ollama, follow [the ollama installation steps](https://github.com/ollama/ollama). Make sure the model works by running `ollama run modelname` (modelname could be llama2 for instance) inside of your terminal. If it does and it responds, you can move to the configuration step

##### OpenAI
If you now reload neovim and try doing `:NAI test` you probably get an error saying that you need a valid API key. Let's get it then!

You'll need to create an openai account and generate the API key from [their interface](https://platform.openai.com/api-keys). Then take the api key and execute `:NAISetup <yourkey>` inside of nvim.

You'll also have to add credits to your account. At the time of writing this the lowest amount you have to spend is 5 dollars. You can do it from [here](https://platform.openai.com/account/billing/overview).

Reload nvim and voilà, you should be able to type the prompt I mentioned at the beginning `:NAI tell me how the universe was created` and get a response back.

## Configuration
You must specify which integration you're about to use
integration - accepts "ollama" or "openai".
```
{
  integration = "openai",
  ...
}
```

### Ollama
You can specify the model that you want to run. You can list all available models by running `ollama list` in the terminal. For more info refer to the ollama documentation.
model - accepts a string you get as the NAME from `ollama list`
```
{
  ...
  ollama = {
    model = "llama2",
  },
}
```
### OpenAI 
You can find all available models [listed here](https://openai.com/pricing). Just copy their name and paste it into the config as `model`.
model - accepts any available model listed by openai
max_tokens - limit the tokens per request
```
{
  ...
  openai = {
    model = "gpt-3.5-turbo-0125",
    max_tokens = 100,
  },
  ...
}
```


