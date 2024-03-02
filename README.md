# Nvim, Ay?

> That's a cool name, AY? nvimai. Nvim, Ay? Whatever.

It's a plugin made to help with an AI addiction. Now we can code confidently knowing that at every moment we can go for the quick `:NAI tell me how the universe was created` to calm ourselves down a bit. Definitely being serious there.

## I want it ay!

Alrighty, it's very simple to install actually! Installing is not the entirety of it unfortunately. _You also have to give money to Microsoft_ ssssh! Now that you're aware, we shall start :nerdwithverybigglasses:

### Installation

```lua
-- Using lazy
{
    "ZirixCZ/nvimai",
    opts = {
      model = "gpt-4-0125-preview",
      max_tokens = 1000,
      api_key = "follow next steps to get this",
    },
},

-- Other package managers will be a tad different.
-- You might need to do something like this
local nvimai = require("nvimai").setup({
  max_tokens = 1000,
  model = "gpt-4-0125-preview",
  api_key = "follow next steps to get this"
})
```

The first step is to install the plugin and to make sure it's installed. It can be installed with your package manager of choice. Above there's an example of using Lazy, but Plug or Packer shouldn't have it too different.
If you now reload neovim and try doing `:NAI test` you probably get an error saying that you need a valid API key. Let's get it then!

### API Token

You'll need to create an openai account and generate the API key from [their interface](https://platform.openai.com/api-keys). Then take the api key and put it into your nvim config like so

```lua
{
    "ZirixCZ/nvimai",
    opts = {
      model = "gpt-4-0125-preview",
      max_tokens = 1000,
      api_key = "place it here",
    },
},
```

You'll also have to add credits to your account. At the time of writing this the lowest amount you have to spend is 5 dollars. You can do it from [here](https://platform.openai.com/account/billing/overview).

Reload nvim and voilà, you should be able to type the prompt I mentioned at the beginning `:NAI tell me how the universe was created` and get a response back, calming your cravings.

## Showcase 

https://github.com/ZirixCZ/nvimai/assets/49836430/ffc4940e-07d9-4229-81c1-3727b017495f

