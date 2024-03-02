local M = {}

local buffer = nil
local window = nil

local config = {
	api_key = "",
	max_tokens = 1000,
	model = "gpt-3.5-turbo-0125",
}

function M.setup(options)
	if options then
		for key, value in pairs(options) do
			if config[key] ~= nil and type(config[key]) == "table" then
				for sub_key, sub_value in pairs(value) do
					config[key][sub_key] = sub_value
				end
			else
				config[key] = value
			end
		end
	end

	return M
end

function M.save_buffer_to_file()
	local path = vim.fn.stdpath("data") .. "/chatgpt_history.txt"
	if buffer and vim.api.nvim_buf_is_valid(buffer) then
		local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
		vim.fn.writefile(lines, path)
	end
end

function M.load_buffer_from_file()
	local path = vim.fn.stdpath("data") .. "/chatgpt_history.txt"
	if vim.fn.filereadable(path) == 1 then
		local lines = vim.fn.readfile(path)
		if not buffer or not vim.api.nvim_buf_is_valid(buffer) then
			buffer = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_buf_set_option(buffer, "bufhidden", "hide")
		end
		vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
	end
end

function M.extract_language_and_code(content)
	local lang_pattern = "```([a-zA-Z0-9_]+)[\n\r]"
	local code_pattern = "```[a-zA-Z0-9_]+[\n\r](.-)```"

	local language = content:match(lang_pattern)
	local code = content:match(code_pattern)

	if code then
		code = code:gsub("^%s+", ""):gsub("%s+$", "")
	end

	return language or "text", code or content
end

function M.open_window(content, filetype, tokens)
	if buffer == nil or not vim.api.nvim_buf_is_valid(buffer) then
		buffer = vim.api.nvim_create_buf(true, false)
	end

	vim.api.nvim_buf_set_option(buffer, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buffer, "bufhidden", "hide")
	vim.api.nvim_buf_set_option(buffer, "swapfile", false)

	local line_count = vim.api.nvim_buf_line_count(buffer)
	if line_count == 1 then
		line_count = 0
	end

	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	local header = "-- " .. timestamp .. " --"
	local model = "-- " .. config.model .. " --"
	local token_info = "-- tokens used: " .. tokens .. " --"

	local new_content = vim.split(content, "\n")

	local formatted_content = { header, token_info, model, "" }
	for _, line in ipairs(new_content) do
		table.insert(formatted_content, line)
	end
	table.insert(formatted_content, "")

	vim.api.nvim_buf_set_lines(buffer, line_count, -1, false, formatted_content)
	vim.api.nvim_buf_set_option(buffer, "filetype", filetype or "text")

	if window == nil or not vim.api.nvim_win_is_valid(window) then
		vim.cmd("new")

		window = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(window, buffer)
	else
		vim.api.nvim_set_current_win(window)
	end

	M.save_buffer_to_file()
end

function M.chatgpt(input)
	M.load_buffer_from_file()

	local api_key = config.api_key
	local model = config.model
	local max_tokens = config.max_tokens

	if api_key == "" then
		local setupMessage = [[
No API key found. Please set it up with:

Lazy:
{
  "zirixcz/nvimai",
  opts = {
    model = "gpt-4-0125-preview",
    max_tokens = 1000,
    api_key = "yourapikey",
  },
}

Or with require:
require('nvimai').setup({
  model = "gpt-4-0125-preview",
  max_tokens = 1000,
  api_key = "yourapikey"
})
    ]]
		M.open_window(setupMessage, "", 0)
		return
	end

	local data = string.format(
		'{"model": "%s", "max_tokens": %d, "messages": [{"role": "user", "content": "%s"}]}',
		model,
		max_tokens,
		input
	)

	vim.fn.jobstart({
		"curl",
		"-s",
		"-X",
		"POST",
		"-H",
		"Content-Type: application/json",
		"-H",
		"Authorization: Bearer " .. api_key,
		"--data",
		data,
		"https://api.openai.com/v1/chat/completions",
	}, {
		stdout_buffered = true,

		on_stdout = function(_, data, _)
			if data then
				local response = table.concat(data, "")
				local decoded = vim.fn.json_decode(response)
				if decoded.choices and decoded.choices[1] then
					local message = decoded.choices[1].message.content
					local tokens = decoded.usage.total_tokens
					if message then
						local language, code = M.extract_language_and_code(message)
						M.open_window(code, language, tokens)
					else
						M.open_window("Received an unexpected structure from API.", "", 0)
					end
				else
					M.open_window("No choices returned from API.", "", 0)
				end
			end
		end,
		on_stderr = function(_, data, _)
			if data then
				for _, line in ipairs(data) do
					print("stderr line:", line)
				end

				local all_lines = table.concat(data, "")
				if all_lines ~= "" then
					local error_message = "Error: " .. all_lines
					M.open_window(error_message, "", 0)
				end
			end
		end,
	})
end

return M
