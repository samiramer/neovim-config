local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

neogen.setup {
  enable = true,
  snippet_engine = "luasnip"
}
