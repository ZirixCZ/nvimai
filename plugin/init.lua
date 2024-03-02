vim.api.nvim_create_user_command("NAI", function(input)
	require("nvimai").magic(input.args)
end, { nargs = "+" })
