-- vis-copy-cut-paste.lua
-- Clipboard copy, cut and paste plugin for vis

local M = {}

-- Copy selected text to clipboard
function M.copy_selection()
	local win = vis.win
	local sel = win.selection

	if sel and sel.range then
		local text = win.file:content(sel.range)

		-- Debug output to inspect selection
        -- vis:info("text: " .. text)

        local tmpfile = os.tmpname()
        local file = io.open(tmpfile, "w")
        if not file then
            vis:info("Failed to create temporary file.")
            return
        end

        file:write(text)
        file:close()

        -- Execute clipboard command and ensure tmpfile is removed
        local success, result = pcall(function()
            return os.execute(string.format("vis-clipboard --copy < %s", tmpfile))
        end)
        os.remove(tmpfile)

        if success and (result == 0 or result == true) then
            vis:feedkeys("<Escape>")
        else
            vis:info("Failed to copy to clipboard: vis-clipboard command failed.")
        end
	end
end

-- Cut selected text to clipboard
function M.cut_selection()
	local win = vis.win
	local sel = win.selection

	if sel and sel.range and sel.range.start ~= sel.range.finish then
		local start = sel.range.start
		local finish = sel.range.finish
		local text = win.file:content(sel.range)

        -- Debug output to inspect selection
        -- vis:info("start: " .. start .. ", finish: " .. finish .. ", text: " .. text)

        local tmpfile = os.tmpname()
        local file = io.open(tmpfile, "w")
        if not file then
            vis:info("Failed to create temporary file.")
            return
        end

        file:write(text)
        file:close()

        -- Execute clipboard command and ensure tmpfile is removed
        local success, result = pcall(function()
            return os.execute(string.format("vis-clipboard --copy < %s", tmpfile))
        end)
        os.remove(tmpfile)

        if success and (result == 0 or result == true) then
            win.file:delete(start, finish - start)
            win.selection.pos = start
            vis:feedkeys("<Escape>")
        else
            vis:info("Failed to copy to clipboard: vis-clipboard command failed.")
        end
	else
		vis:info("No text selected.")
	end
end

-- Paste clipboard contents at cursor position
function M.paste_clipboard()
	local tmpfile = os.tmpname()
	local command = string.format("vis-clipboard --paste > %s 2>/dev/null", tmpfile)
	local result = os.execute(command)

	if result == 0 or result == true then
		local file = io.open(tmpfile, "r")
		if file then
			local text = file:read("*a")
			file:close()
			os.remove(tmpfile)

			if text == nil or text == "" then
				vis:info("Clipboard is empty.")
				return
			end

			local win = vis.win
			local pos = win.selection.pos or 0
			win.file:insert(pos, text)
			win.selection.pos = pos + #text
		else
			vis:info("Failed to read from clipboard temporary file.")
		end
	else
		vis:info("Clipboard content not available or is empty.")
		os.remove(tmpfile)
	end
end


-- Register keybindings
vis:map(vis.modes.VISUAL, "<C-c>", M.copy_selection)
vis:map(vis.modes.VISUAL, "<C-x>", M.cut_selection)

for _, mode in ipairs({vis.modes.INSERT, vis.modes.NORMAL, vis.modes.VISUAL}) do
	vis:map(mode, "<C-v>", M.paste_clipboard)
end

-- Optional: select all with Ctrl+A in all modes
for _, mode in ipairs({vis.modes.NORMAL, vis.modes.VISUAL, vis.modes.INSERT}) do
	vis:map(mode, "<C-a>", function()
		vis:feedkeys("<Escape>ggVG")
	end)
end

return M
