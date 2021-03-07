function probe()
    return vlc.access == "https" and (string.match(vlc.path, 'youtube.com/playlist'))
end

function getstr(s)
    local t1 = s:find('playlistVideoListRenderer')
    local t2 = s:find('isEditable')
    return s:sub(t1 + 25, t2 - 1)
end

function parse()
	local list = {}
    local html = vlc.read(500000)
	if string.match(vlc.path, 'playlist') then
		html = getstr(html)
		for t, n in html:gmatch('playlistVideoRenderer":{"videoId":"(.-)",.-title":{"runs":.{"text":"(.-)"}') do
			table.insert(list, {path = 'https://www.youtube.com/watch?v='..t, name = n:gsub('\\"', '"'):gsub('\\u0026', '&')})
		end
	end
    return list
end