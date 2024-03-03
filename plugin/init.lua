local nvimai = require("nvimai")

vim.api.nvim_create_user_command("NAI", function(input)
	nvimai.router(input.args)
end, { nargs = "+" })

vim.api.nvim_create_user_command("NAISetup", function(input)
	nvimai.save_api_key_to_file(input.args)
end, { nargs = 1 })
